defmodule PhoenixMultivitaminWeb.HeraklionKnossosPresenceLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/02-heraklion-knossos-presence"
  @topic "presence:heraklion-tower"

  test "controllers are grouped under the position they track", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Giorgos&position=tower")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "Katerina", %{position: "ground"}, view)
    PresenceSync.track_peer(Presence, @topic, "Manolis", %{position: "ground"}, view)

    assert has_element?(view, "#position-tower [data-controller='Giorgos']")
    assert has_element?(view, "#position-ground [data-controller='Katerina']")
    assert has_element?(view, "#position-ground [data-controller='Manolis']")
    assert has_element?(view, "#position-delivery", "Unstaffed")
  end

  test "the runway change waits for the duty supervisor", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Giorgos&position=apron")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#position-ground [data-controller='Giorgos']")
    assert has_element?(view, "#supervisor-watch", "has not plugged in")

    supervisor =
      PresenceSync.track_peer(Presence, @topic, "Eleni", %{position: "supervisor"}, view)

    assert has_element?(view, "#supervisor-watch", "Eleni is on watch at supervisor")

    PresenceSync.drop(Presence, supervisor, view)
    assert has_element?(view, "#supervisor-watch", "has not plugged in")
  end

  test "get_by_key/2 returns a metas map for a present key and an empty list for an absent one" do
    assert Presence.get_by_key(@topic, "Eleni") == []

    PresenceSync.track_peer(Presence, @topic, "Eleni", %{position: "supervisor"})

    assert %{metas: [%{position: "supervisor", phx_ref: _ref}]} =
             Presence.get_by_key(@topic, "Eleni")
  end
end
