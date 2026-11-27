defmodule PhoenixMultivitaminWeb.TallinnToompeaRoundLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/10-tallinn-toompea-round"
  @topic "presence:tallinn-runway-round"

  test "inspectors are streamed in and deleted by DOM id", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?inspector=Kadri")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#inspector-kadri", "Follow-me 2")
    assert has_element?(view, "#round-count", "1 inspector on the round")

    sweeper =
      PresenceSync.track_peer(
        Presence,
        @topic,
        "Rasmus",
        %{vehicle: "Sweeper 1", segment: "TWY B"},
        view
      )

    assert has_element?(view, "#inspector-rasmus", "Sweeper 1 · TWY B")
    assert has_element?(view, "#round-count", "2 inspectors on the round")

    PresenceSync.drop(Presence, sweeper, view)
    refute has_element?(view, "#inspector-rasmus")
    assert has_element?(view, "#round-count", "1 inspector on the round")
  end

  test "an updated segment replaces the streamed row in place", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?inspector=Kadri")
    PresenceSync.release_on_exit(view, Presence)

    friction =
      PresenceSync.track_peer(
        Presence,
        @topic,
        "Mart",
        %{vehicle: "Friction tester", segment: "RWY 08 threshold"},
        view
      )

    {:ok, _ref} = Presence.update(friction, @topic, "Mart", &%{&1 | segment: "RWY 26 threshold"})
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#inspector-mart", "RWY 26 threshold")
    assert has_element?(view, "#round-count", "2 inspectors on the round")
  end

  test "an inspector who closes one of several screens stays streamed", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?inspector=Kadri")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(
      Presence,
      @topic,
      "Kadri",
      %{vehicle: "Follow-me 2", segment: "Apron 3"},
      view
    )

    second_screen =
      PresenceSync.track_peer(
        Presence,
        @topic,
        "Kadri",
        %{vehicle: "Follow-me 2", segment: "TWY Y"},
        view
      )

    assert has_element?(view, "#inspector-kadri .screen-count", "3 screens")

    PresenceSync.drop(Presence, second_screen, view)

    assert has_element?(view, "#inspector-kadri .screen-count", "2 screens")
    assert has_element?(view, "#round-count", "1 inspector on the round")
  end
end
