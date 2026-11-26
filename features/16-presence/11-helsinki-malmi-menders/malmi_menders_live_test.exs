defmodule PhoenixMultivitaminWeb.HelsinkiMalmiMendersLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/11-helsinki-malmi-menders"
  @topic "presence:malmi-hangar-2"

  test "the shift lead observes without being counted", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#observer-note")
    assert has_element?(view, "#tally-menders", "0")
    assert has_element?(view, ".grade-grounded")
    assert Presence.list(@topic) == %{}
  end

  test "menders count once each while screens count every tablet", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "Antti", %{trade: "powerplant"}, view)
    PresenceSync.track_peer(Presence, @topic, "Antti", %{trade: "powerplant"}, view)
    PresenceSync.track_peer(Presence, @topic, "Sanna", %{trade: "airframe"}, view)

    assert has_element?(view, "#tally-menders", "2")
    assert has_element?(view, "#tally-screens", "3")
    assert has_element?(view, "#tally-powerplant", "1")
    assert has_element?(view, ".grade-thin", "Thin shift")
  end

  test "the hangar is staffed once every trade has a mender", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?mender=Mikko&trade=avionics")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "Antti", %{trade: "powerplant"}, view)
    PresenceSync.track_peer(Presence, @topic, "Sanna", %{trade: "airframe"}, view)

    refute has_element?(view, "#observer-note")
    assert has_element?(view, "#tally-avionics", "1")
    assert has_element?(view, ".grade-staffed")
  end

  test "an unknown trade is tracked as airframe", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?mender=Mikko&trade=upholstery")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert %{"Mikko" => %{metas: [%{trade: "airframe"}]}} = Presence.list(@topic)
  end
end
