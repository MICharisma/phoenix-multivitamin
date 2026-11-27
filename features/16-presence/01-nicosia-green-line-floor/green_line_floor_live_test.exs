defmodule PhoenixMultivitaminWeb.NicosiaGreenLineFloorLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/01-nicosia-green-line-floor"
  @topic "presence:nicosia-acc-floor"

  test "the disconnected render tracks nobody", %{conn: conn} do
    html = conn |> get(@path <> "?controller=Andreas") |> html_response(200)

    assert html =~ "The floor list opens when your console connects."
    assert Presence.list(@topic) == %{}
  end

  test "the connected console tracks itself and sees a colleague arrive and leave", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Andreas&sector=Larnaca+Approach")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#floor-andreas", "Larnaca Approach")
    refute has_element?(view, "#floor-pending")

    colleague =
      PresenceSync.track_peer(Presence, @topic, "Eleni", %{sector: "Paphos Approach"}, view)

    assert has_element?(view, "#floor-eleni", "Paphos Approach")

    PresenceSync.drop(Presence, colleague, view)
    refute has_element?(view, "#floor-eleni")
    assert has_element?(view, "#floor-andreas")
  end

  test "an unknown sector falls back to Nicosia East", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?controller=Stelios&sector=Ercan")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#floor-stelios", "Nicosia East")
    assert %{"Stelios" => %{metas: [%{sector: "Nicosia East"}]}} = Presence.list(@topic)
  end
end
