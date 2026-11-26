defmodule PhoenixMultivitaminWeb.ChristchurchWatchSessionLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/09-christchurch-watch-session"

  test "without a session the board opens on relief", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "relief")
    assert has_element?(view, "#watch-name", "relief")
    assert has_element?(view, "#session-seeded", "false")
  end

  test "init_test_session seeds Aroha onto the evening watch", %{conn: conn} do
    conn = init_test_session(conn, %{"plains_controller" => "Aroha"})
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Aroha")
    assert has_element?(view, "#watch-name", "evening")
    assert has_element?(view, "#session-seeded", "true")
    assert has_element?(view, "#craft-name", "ATR 72")
  end

  test "init_test_session seeds Tane onto midwatch", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{"plains_controller" => "Tane"})
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Tane")
    assert has_element?(view, "#watch-name", "midwatch")
  end
end
