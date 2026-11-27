defmodule PhoenixMultivitaminWeb.MadinahHijazHoldWireLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/11-madinah-hijaz-hold-wire"
  @topic "madinah:hijaz-holds"
  @pubsub PhoenixMultivitamin.PubSub

  defp issue_hold(view, reach, fix) do
    view |> form("#hold-form", reach: reach, fix: fix, minutes: "12") |> render_submit()
  end

  test "cluster and node reaches land on this single node's desks", %{conn: conn} do
    {:ok, wire, _html} = live(conn, @path)
    assert has_element?(wire, "#node-name", ":nonode@nohost")
    assert has_element?(wire, "#connected-nodes", "0")

    issue_hold(wire, "cluster", "TAYBA")
    assert has_element?(wire, "#hold-log li", "Hold TAYBA 12 min via cluster")

    issue_hold(wire, "node", "KHAYB")
    assert has_element?(wire, "#hold-log li", "Hold KHAYB 12 min via node")
  end

  test "a direct broadcast to this node's name is relayed by the adapter worker", %{conn: conn} do
    {:ok, wire, _html} = live(conn, @path)
    adapter_worker = Process.whereis(Module.concat(@pubsub, "Adapter"))

    issue_hold(wire, "direct", "BADRA")
    _ = :sys.get_state(adapter_worker)

    assert has_element?(wire, "#hold-log li", "Hold BADRA 12 min via direct")
  end

  test "direct_broadcast arrives after the call returns; local_broadcast before" do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
    adapter_worker = Process.whereis(Module.concat(@pubsub, "Adapter"))
    :erlang.suspend_process(adapter_worker)

    :ok = Phoenix.PubSub.direct_broadcast(node(), @pubsub, @topic, {:hijaz_hold, fix: "TAYBA"})
    :ok = Phoenix.PubSub.local_broadcast(@pubsub, @topic, {:hijaz_hold, fix: "KHAYB"})

    assert_received {:hijaz_hold, fix: "KHAYB"}
    refute_received {:hijaz_hold, fix: "TAYBA"}

    :erlang.resume_process(adapter_worker)
    assert_receive {:hijaz_hold, fix: "TAYBA"}
  end

  test "a direct broadcast to an absent node returns :ok and delivers nothing", %{conn: conn} do
    {:ok, wire, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(@pubsub, @topic)

    issue_hold(wire, "riyadh", "TAYBA")

    assert has_element?(wire, "#last-reach", "riyadh")
    refute has_element?(wire, "#hold-log li")
    refute_receive {:hijaz_hold, _details}, 50
  end

  test "an unknown reach or fix sends nothing", %{conn: conn} do
    {:ok, wire, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(@pubsub, @topic)

    render_submit(wire, "issue_hold", %{"reach" => "jeddah", "fix" => "TAYBA", "minutes" => "5"})
    assert has_element?(wire, "#flash-error", "No such reach")

    render_submit(wire, "issue_hold", %{"reach" => "cluster", "fix" => "QUBAA", "minutes" => "5"})
    assert has_element?(wire, "#flash-error", "not a Hijaz holding fix")

    refute_received {:hijaz_hold, _details}
  end
end
