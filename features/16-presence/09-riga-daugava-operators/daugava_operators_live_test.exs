defmodule PhoenixMultivitaminWeb.RigaDaugavaOperatorsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.PresenceSync
  alias PhoenixMultivitaminWeb.RigaDaugavaPresence, as: OpsPresence

  @path "/features/16-presence/09-riga-daugava-operators"
  @topic "presence:riga-ops-control"

  test "list/1 carries the roster profile beside the metas", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?licence=LV-OCC-1184&console=OCC-3")
    PresenceSync.release_on_exit(view, OpsPresence)
    PresenceSync.settle(OpsPresence, view)

    assert has_element?(view, "#operator-LV-OCC-1184 .operator-name", "Jānis Bērziņš")
    assert has_element?(view, "#operator-LV-OCC-1184", "lv / en / ru")

    assert %{"LV-OCC-1184" => %{metas: [%{console: "OCC-3"}], profile: %{desk: "Crew control"}}} =
             OpsPresence.list(@topic)
  end

  test "fetch/2 also overlays the profile onto leaves in a presence_diff", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?licence=LV-OCC-4420")
    PresenceSync.release_on_exit(view, OpsPresence)
    PresenceSync.settle(OpsPresence, view)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    maintenance =
      PresenceSync.track_peer(OpsPresence, @topic, "LV-OCC-2207", %{console: "OCC-2"}, view)

    assert has_element?(view, "#ops-ticker li", "Ilze Kalniņa joined the ops room")

    PresenceSync.drop(OpsPresence, maintenance, view)

    assert_received %Phoenix.Socket.Broadcast{
      event: "presence_diff",
      payload: %{leaves: %{"LV-OCC-2207" => %{profile: %{name: "Ilze Kalniņa"}}}}
    }

    assert has_element?(view, "#ops-ticker li:first-child", "Ilze Kalniņa left the ops room")
    refute has_element?(view, "#operator-LV-OCC-2207")
  end

  test "an unrostered licence is shown with a warning", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?licence=EE-OCC-0091")
    PresenceSync.release_on_exit(view, OpsPresence)
    PresenceSync.settle(OpsPresence, view)

    assert has_element?(view, "#operator-EE-OCC-0091 .operator-name", "Unrostered licence")
    assert has_element?(view, "#operator-EE-OCC-0091 .unrostered")
  end
end
