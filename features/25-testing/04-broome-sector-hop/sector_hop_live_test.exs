defmodule PhoenixMultivitaminWeb.BroomeSectorHopLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/04-broome-sector-hop"
  @hold @path <> "/hold"

  test "assert_patch keeps the mount when Pearl opens", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#sector-name", "cable")

    view |> element("#open-pearl") |> render_click()
    assert_patch(view, @path <> "?sector=pearl")
    assert has_element?(view, "#sector-name", "pearl")
  end

  test "follow_redirect lands on the hold board", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    {:ok, hold_view, _html} =
      view
      |> element("#open-hold")
      |> render_click()
      |> follow_redirect(conn, @hold)

    assert has_element?(hold_view, "#surface-name", "hold")
    assert has_element?(hold_view, "#clerk-name", "Jarrah")
  end
end
