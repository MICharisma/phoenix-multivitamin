defmodule PhoenixMultivitaminWeb.SantoriniCalderaDeskLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.PresenceSync
  alias PhoenixMultivitaminWeb.SantoriniCalderaPresence, as: DeskPresence

  @path "/features/16-presence/03-santorini-caldera-desk"
  @topic "presence:santorini-caldera-desk"

  setup do
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic <> ":log")
    :ok
  end

  test "a desk arrival is logged with the counter it took", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Nikos&counter=gate")
    PresenceSync.release_on_exit(view, DeskPresence)
    PresenceSync.settle(DeskPresence, view)

    assert_received {:caldera_desk, {:took_desk, "Nikos", "Gate B2", _handover}}
    assert has_element?(view, "#desk-log li", "Nikos took the caldera desk at Gate B2")
  end

  test "a second console and its closing are not arrivals or departures", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Maria")
    PresenceSync.release_on_exit(view, DeskPresence)
    PresenceSync.settle(DeskPresence, view)

    tablet =
      PresenceSync.track_peer(DeskPresence, @topic, "Maria", %{counter: "Transfer desk"}, view)

    assert_received {:caldera_desk, {:second_console, "Maria", 2}}
    assert has_element?(view, "#desk-log li", "Maria opened another console (2 open)")

    PresenceSync.drop(DeskPresence, tablet, view)
    assert_received {:caldera_desk, {:closed_console, "Maria", 1}}
    assert has_element?(view, "#desk-log li", "Maria closed a console and is still at the desk")
    refute has_element?(view, "#desk-log li", "Maria left the caldera desk")
  end

  test "the last console closing is a departure", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Maria")
    PresenceSync.release_on_exit(view, DeskPresence)
    PresenceSync.settle(DeskPresence, view)

    relief =
      PresenceSync.track_peer(DeskPresence, @topic, "Dimitris", %{counter: "Check-in 4"}, view)

    assert has_element?(view, "#desk-log li", "Dimitris took the caldera desk at Check-in 4")

    PresenceSync.drop(DeskPresence, relief, view)
    assert_received {:caldera_desk, {:left_desk, "Dimitris"}}
    assert has_element?(view, "#desk-log li", "Dimitris left the caldera desk")
  end
end
