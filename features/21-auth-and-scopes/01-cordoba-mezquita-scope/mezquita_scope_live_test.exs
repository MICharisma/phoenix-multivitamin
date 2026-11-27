defmodule PhoenixMultivitaminWeb.CordobaMezquitaScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/21-auth-and-scopes/01-cordoba-mezquita-scope"

  test "without a badge the hangar shows the guest board", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Lucía")
    assert has_element?(view, "#craft-name", "ATR 72-600")
    assert has_element?(view, "#guest-board")
    refute has_element?(view, "#mezquita-board")
  end

  test "mezquita_badge session builds a scope for Lucía at COR", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("mezquita_badge", "lucia-cor")
      |> live(@path)

    assert has_element?(view, "#scope-controller", "Lucía")
    assert has_element?(view, "#scope-station", "COR")
    assert has_element?(view, "#desk-state", "Mezquita hangar open")
    refute has_element?(view, "#guest-board")
  end
end
