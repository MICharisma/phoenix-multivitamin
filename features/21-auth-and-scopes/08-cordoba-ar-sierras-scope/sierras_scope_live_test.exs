defmodule PhoenixMultivitaminWeb.CordobaSierrasScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/21-auth-and-scopes/08-cordoba-ar-sierras-scope"

  test "public winds board is visible without a scope", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Emilia")
    assert has_element?(view, "#craft-name", "Cessna 208B Caravan")
    assert has_element?(view, "#sierras-winds-board")
    assert has_element?(view, "#wind-fl090", "FL090")
    assert has_element?(view, "#sierras-guest-panel")
    refute has_element?(view, "#sierras-charter-panel")
  end

  test "open_charter_desk is rejected without a scope", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#open-charter-desk") |> render_click()

    assert has_element?(view, "#desk-message", "Sign in before the charter desk unlocks")
    assert render(view) =~ "Authenticated scope required"
  end

  test "authenticated Emilia sees the charter panel and can open the desk", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("sierras_clerk", "Emilia")
      |> live(@path)

    assert has_element?(view, "#sierras-winds-board")
    assert has_element?(view, "#sierras-charter-panel")
    assert has_element?(view, "#scope-clerk", "Emilia")
    assert has_element?(view, "#scope-station", "COR")
    refute has_element?(view, "#sierras-guest-panel")

    view |> element("#open-charter-desk") |> render_click()

    assert has_element?(view, "#charter-desk-state", "open")
    assert has_element?(view, "#desk-message", "Charter desk open for Emilia at COR")
  end
end
