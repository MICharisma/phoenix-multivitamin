defmodule PhoenixMultivitaminWeb.TurkuArchipelagoCrewLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/12-turku-archipelago-crew"
  @topic "presence:turku-seaplane-crew"

  test "a killed crew tab leaves presence and goes under radio silence", %{conn: conn} do
    {:ok, coordinator, _html} = live(conn, @path <> "?crew=Aino")
    PresenceSync.release_on_exit(coordinator, Presence)
    PresenceSync.settle(Presence, coordinator)

    tablet =
      PresenceSync.track_peer(Presence, @topic, "Eero", %{post: "Korpo pontoon"}, coordinator)

    assert has_element?(coordinator, "#on-air-Eero", "Korpo pontoon")

    PresenceSync.drop(Presence, tablet, coordinator)

    assert Presence.get_by_key(@topic, "Eero") == []
    refute has_element?(coordinator, "#on-air-Eero")
    assert has_element?(coordinator, "#silent-Eero", "last heard at Korpo pontoon")
  end

  test "radio silence fades when its timer fires", %{conn: conn} do
    {:ok, coordinator, _html} = live(conn, @path <> "?crew=Aino")
    PresenceSync.release_on_exit(coordinator, Presence)

    pilot =
      PresenceSync.track_peer(Presence, @topic, "Saara", %{post: "Utö fuel barge"}, coordinator)

    PresenceSync.drop(Presence, pilot, coordinator)
    assert has_element?(coordinator, "#silent-Saara")

    send(coordinator.pid, {:fade, "Saara"})
    refute has_element?(coordinator, "#silent-Saara")
  end

  test "a crew member who comes back is taken out of radio silence", %{conn: conn} do
    {:ok, coordinator, _html} = live(conn, @path <> "?crew=Aino")
    PresenceSync.release_on_exit(coordinator, Presence)

    deckhand =
      PresenceSync.track_peer(Presence, @topic, "Ville", %{post: "Nauvo jetty"}, coordinator)

    PresenceSync.drop(Presence, deckhand, coordinator)
    assert has_element?(coordinator, "#silent-Ville")

    PresenceSync.track_peer(Presence, @topic, "Ville", %{post: "Houtskär ramp"}, coordinator)

    refute has_element?(coordinator, "#silent-Ville")
    assert has_element?(coordinator, "#on-air-Ville", "Houtskär ramp")
  end
end
