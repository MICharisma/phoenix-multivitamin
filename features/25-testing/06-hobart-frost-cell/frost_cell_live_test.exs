defmodule PhoenixMultivitaminWeb.HobartFrostCellLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/06-hobart-frost-cell"

  test "the frost cell keeps taps under its own id", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Elspeth")
    assert has_element?(view, "#frost-taps", "0")
    assert has_element?(view, "#parent-taps", "0")

    view |> element("#tap-frost") |> render_click()
    assert has_element?(view, "#frost-taps", "1")
    assert has_element?(view, "#parent-taps", "1")
  end

  test "send_update writes a Derwent note onto the cell", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#post-note") |> render_click()
    assert has_element?(view, "#frost-note", "Derwent frost noted")
  end
end
