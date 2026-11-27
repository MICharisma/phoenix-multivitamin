defmodule PhoenixMultivitaminWeb.WellingtonTagRangeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/10-wellington-tag-range"

  test "the catalog page lists Cook Strait and Harbour", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Moana")
    assert has_element?(view, "#sector-cook", "cook")
    assert has_element?(view, "#sector-harbour", "harbour")
  end
end
