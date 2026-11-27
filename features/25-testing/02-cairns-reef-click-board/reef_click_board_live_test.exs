defmodule PhoenixMultivitaminWeb.CairnsReefClickBoardLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/02-cairns-reef-click-board"

  test "live/2 connects and has_element?/3 locks the clerk", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Cairns reef click board"
    assert has_element?(view, "#clerk-name", "Marlee")
    assert has_element?(view, "#craft-name", "Twin Otter")
    assert has_element?(view, "#reef-state", "clear")
    assert has_element?(view, "#empty-reef")
  end

  test "render_click posts bommie and turtle lines through element/3", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#log-bommie") |> render_click()
    assert has_element?(view, "#reef-hazards", "Bommie marked east of Green Island")
    assert has_element?(view, "#reef-state", "caution")
    refute has_element?(view, "#empty-reef")

    view |> element("#log-turtle") |> render_click()
    assert has_element?(view, "#reef-hazards", "Green turtle raft")
    assert has_element?(view, "#reef-state", "hold")

    view |> element("#clear-reef") |> render_click()
    assert has_element?(view, "#empty-reef")
    assert has_element?(view, "#reef-state", "clear")
  end
end
