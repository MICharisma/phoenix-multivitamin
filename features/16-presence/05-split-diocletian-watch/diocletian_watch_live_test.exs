defmodule PhoenixMultivitaminWeb.SplitDiocletianWatchLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/05-split-diocletian-watch"
  @topic "presence:split-approach-watch"

  test "joins and leaves are folded into the roster", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Ante")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#watch-ante", "119.100")

    relief = PresenceSync.track_peer(Presence, @topic, "Marija", %{frequency: "121.000"}, view)
    assert has_element?(view, "#watch-marija", "121.000")

    PresenceSync.drop(Presence, relief, view)
    refute has_element?(view, "#watch-marija")
    assert has_element?(view, "#watch-ante")
  end

  test "a meta update arrives as a leave and a join for the same key", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Ante")
    PresenceSync.release_on_exit(view, Presence)
    relief = PresenceSync.track_peer(Presence, @topic, "Marija", %{frequency: "121.000"}, view)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok, _ref} = Presence.update(relief, @topic, "Marija", %{frequency: "124.875"})
    PresenceSync.settle(Presence, view)

    assert_received %Phoenix.Socket.Broadcast{
      event: "presence_diff",
      payload: %{
        leaves: %{"Marija" => %{metas: [%{frequency: "121.000", phx_ref: old_ref}]}},
        joins: %{"Marija" => %{metas: [%{frequency: "124.875", phx_ref_prev: old_ref}]}}
      }
    }

    assert has_element?(view, "#watch-marija dd", "124.875")
    refute has_element?(view, "#watch-marija dd", "121.000")
  end

  test "the roster is seeded by one list and then only by diffs", %{conn: conn} do
    PresenceSync.track_peer(Presence, @topic, "Tomislav", %{frequency: "118.800"})

    {:ok, view, _html} = live(conn, @path <> "?controller=Ante")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#watch-tomislav", "118.800")
    assert has_element?(view, "#diffs-applied", "1 presence diffs folded in")
  end
end
