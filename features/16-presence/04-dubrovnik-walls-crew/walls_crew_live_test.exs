defmodule PhoenixMultivitaminWeb.DubrovnikWallsCrewLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/04-dubrovnik-walls-crew"
  @topic "presence:dubrovnik-apron"

  test "agents at one stand merge into one presence with many metas", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Ivana&stand=4&role=marshaller")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "4", %{agent: "Marko", role: "loader"}, view)
    assert has_element?(view, "#stand-4 .stand-missing", "Missing: fueller")

    PresenceSync.track_peer(Presence, @topic, "4", %{agent: "Petra", role: "fueller"}, view)

    assert has_element?(
             view,
             "#stand-4",
             "Stand 4 · 3 crew: Ivana (marshaller), Marko (loader), Petra (fueller)"
           )

    assert has_element?(view, "#stand-4 .stand-ready")

    assert %{"4" => %{metas: [_, _, _]}} = Presence.list(@topic)
  end

  test "each stand is its own key", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Ivana&stand=11&role=loader")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "2", %{agent: "Josip", role: "marshaller"}, view)

    assert has_element?(view, "#stand-2", "Josip (marshaller)")
    assert has_element?(view, "#stand-11 .stand-missing", "fueller, marshaller")
  end

  test "an unknown role is refused and not tracked", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Luka&stand=6&role=caterer")
    PresenceSync.release_on_exit(view, Presence)

    assert has_element?(view, "#flash-error", "caterer is not a turnaround role.")
    refute has_element?(view, "#stand-6")
    assert Presence.get_by_key(@topic, "6") == []
  end
end
