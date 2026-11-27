defmodule PhoenixMultivitaminWeb.LjubljanaTripleBridgeReliefLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/06-ljubljana-triple-bridge-relief"
  @topic "presence:ljubljana-tower-relief"

  test "a status change updates the meta under the same key", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Mojca")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#relief-mojca", "On position")
    refute has_element?(view, "#relief-mojca .status-changed")

    view |> element("#status-briefing_relief") |> render_click()
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#relief-mojca", "Briefing the relief")
    assert has_element?(view, "#relief-mojca .status-changed")

    assert %{"Mojca" => %{metas: [%{status: "briefing_relief", changes: 1}]}} =
             Presence.list(@topic)
  end

  test "the update diff names the controller in both leaves and joins", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Mojca")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    view |> element("#status-on_break") |> render_click()
    PresenceSync.settle(Presence, view)

    assert_received %Phoenix.Socket.Broadcast{
      event: "presence_diff",
      payload: %{joins: joins, leaves: leaves}
    }

    assert Map.keys(joins) == ["Mojca"]
    assert Map.keys(leaves) == ["Mojca"]
    assert %{"Mojca" => %{metas: [%{status: "on_break", phx_ref_prev: previous}]}} = joins
    assert %{"Mojca" => %{metas: [%{status: "on_position", phx_ref: ^previous}]}} = leaves
  end

  test "an unknown status is refused and the meta is untouched", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Mojca")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    render_click(view, "set_status", %{"status" => "gone_fishing"})

    assert has_element?(view, "#flash-error", "gone_fishing is not a relief status.")
    assert %{"Mojca" => %{metas: [%{status: "on_position", changes: 0}]}} = Presence.list(@topic)
  end
end
