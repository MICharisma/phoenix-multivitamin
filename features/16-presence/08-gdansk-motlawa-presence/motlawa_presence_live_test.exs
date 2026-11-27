defmodule PhoenixMultivitaminWeb.GdanskMotlawaPresenceLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/08-gdansk-motlawa-presence"
  @topic "presence:gdansk-ops-dispatch"

  test "two tabs for one dispatcher are one presence with two metas", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path <> "?dispatcher=Hanna&device=desk")
    PresenceSync.release_on_exit(desk, Presence)
    {:ok, tablet, _html} = live(build_conn(), @path <> "?dispatcher=Hanna&device=tablet")
    PresenceSync.release_on_exit(tablet, Presence)
    PresenceSync.settle(Presence, [desk, tablet])

    assert has_element?(desk, "#dispatcher-hanna .screen-count", "2 screens")
    assert has_element?(desk, "#device-apron-tablet", "Hanna")
    assert has_element?(desk, "#device-ops-desk", "Hanna")
    assert %{"Hanna" => %{metas: [_, _]}} = Presence.list(@topic)
  end

  test "closing one tab leaves the dispatcher present on the other", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path <> "?dispatcher=Hanna&device=desk")
    PresenceSync.release_on_exit(desk, Presence)
    PresenceSync.settle(Presence, desk)

    phone = PresenceSync.track_peer(Presence, @topic, "Hanna", %{device: "duty phone"}, desk)
    assert has_element?(desk, "#dispatcher-hanna .screen-count", "2 screens")

    PresenceSync.drop(Presence, phone, desk)

    assert has_element?(desk, "#dispatcher-hanna .screen-count", "1 screen")
    refute has_element?(desk, "#device-duty-phone")
  end

  test "different dispatchers stay separate and the busiest is listed first", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?dispatcher=Bartosz&device=desk")
    PresenceSync.release_on_exit(view, Presence)
    PresenceSync.settle(Presence, view)

    PresenceSync.track_peer(Presence, @topic, "Zofia", %{device: "ops desk"}, view)
    PresenceSync.track_peer(Presence, @topic, "Zofia", %{device: "apron tablet"}, view)

    assert has_element?(view, "#dispatchers li:first-child", "Zofia")
    assert has_element?(view, "#device-ops-desk dd", "Bartosz, Zofia")
  end
end
