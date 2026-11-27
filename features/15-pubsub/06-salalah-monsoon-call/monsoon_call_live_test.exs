defmodule PhoenixMultivitaminWeb.SalalahMonsoonCallLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/06-salalah-monsoon-call"
  @topic "salalah:monsoon-runway-calls"

  defp runway_call(runway, condition) do
    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:runway_call, runway, condition}
    )
  end

  defp subscriber_pids do
    PhoenixMultivitamin.PubSub |> Registry.lookup(@topic) |> Enum.map(&elem(&1, 0))
  end

  test "calls land only while the desk follows", %{conn: conn} do
    {:ok, apron, _html} = live(conn, @path)
    runway_call("07", "Wet, braking medium")
    refute has_element?(apron, "#runway-calls li")

    apron |> element("#follow-calls") |> render_click()
    runway_call("07", "Wet, braking medium")
    assert has_element?(apron, "#runway-calls li", "07: Wet, braking medium")

    apron |> element("#stop-following") |> render_click()
    runway_call("25", "Standing water")
    refute has_element?(apron, "#runway-calls li", "Standing water")
    assert subscriber_pids() == []
  end

  test "a second follow is refused, so each call lands once", %{conn: conn} do
    {:ok, apron, _html} = live(conn, @path)
    render_click(apron, "follow_calls", %{})
    render_click(apron, "follow_calls", %{})
    assert subscriber_pids() == [apron.pid]

    runway_call("07", "Drizzle, visibility 1200 m")
    assert has_element?(apron, "#runway-calls li", "Drizzle")
    refute has_element?(apron, "#runway-calls li:nth-child(2)")
  end

  test "a duplicate subscription delivers twice and one unsubscribe drops both" do
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
    runway_call("07", "Fog patches")
    assert_received {:runway_call, "07", "Fog patches"}
    assert_received {:runway_call, "07", "Fog patches"}

    Phoenix.PubSub.unsubscribe(PhoenixMultivitamin.PubSub, @topic)
    runway_call("07", "Fog lifting")
    refute_received {:runway_call, "07", "Fog lifting"}
  end

  test "messages the hook passes on are dropped without a handle_info/2", %{conn: conn} do
    {:ok, apron, _html} = live(conn, @path)
    apron |> element("#follow-calls") |> render_click()

    send(apron.pid, {:tide_table, "Raysut", "High water 14:20"})
    runway_call("25", "Damp")

    assert has_element?(apron, "#runway-calls li", "25: Damp")
  end

  test "the subscription goes away with the LiveView process", %{conn: conn} do
    {:ok, apron, _html} = live(conn, @path)
    apron |> element("#follow-calls") |> render_click()
    assert subscriber_pids() == [apron.pid]

    ref = Process.monitor(apron.pid)

    assert {:error, {:live_redirect, %{to: "/"}}} =
             apron |> element("#leave-apron") |> render_click()

    assert_receive {:DOWN, ^ref, :process, _pid, _reason}

    # Registry partitions drop a dead subscriber when they handle its exit signal.
    for {_id, partition, :worker, _modules} <-
          Supervisor.which_children(PhoenixMultivitamin.PubSub) do
      :sys.get_state(partition)
    end

    assert subscriber_pids() == []
  end
end
