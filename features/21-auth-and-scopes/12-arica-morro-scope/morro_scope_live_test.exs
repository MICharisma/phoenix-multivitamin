defmodule PhoenixMultivitaminWeb.AricaMorroScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MorroAuth
  alias PhoenixMultivitaminWeb.MorroScope

  @path "/features/21-auth-and-scopes/12-arica-morro-scope"

  test "can?/2 allows marshaller clear_runway and refuses clerk" do
    diego = MorroScope.for_badge("diego-ari")
    pilar = MorroScope.for_badge("pilar-ari")

    assert MorroAuth.can?(diego, :clear_runway)
    refute MorroAuth.can?(pilar, :clear_runway)
    assert {:ok, :runway_cleared} = MorroAuth.clear_runway(diego)
    assert {:error, :forbidden} = MorroAuth.clear_runway(pilar)
  end

  test "wrong-station Tacna scope is forbidden for the Arica board" do
    tacna = MorroScope.for_badge("diego-tcq")

    assert {:error, :forbidden} = MorroAuth.open_arica_board(tacna)
    refute MorroAuth.can?(tacna, :open_arica_board)
  end

  test "marshaller Diego clears runway 02", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("morro_badge", "diego-ari")
      |> live(@path)

    assert has_element?(view, "#scope-name", "Diego")
    assert has_element?(view, "#scope-role", "marshaller")
    assert has_element?(view, "#can-clear", "yes")

    view |> element("#clear-runway") |> render_click()

    assert has_element?(view, "#runway-state", "cleared")
    assert has_element?(view, "#runway-message", "Diego cleared runway 02")
  end

  test "clerk Pilar cannot clear the runway", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("morro_badge", "pilar-ari")
      |> live(@path)

    assert has_element?(view, "#scope-name", "Pilar")
    assert has_element?(view, "#scope-role", "clerk")
    assert has_element?(view, "#can-clear", "no")

    view |> element("#clear-runway") |> render_click()

    assert has_element?(view, "#runway-state", "occupied")
    assert has_element?(view, "#runway-message", "Marshaller role required")
    assert render(view) =~ "Forbidden"
  end

  test "Tacna badge shows wrong-station refusal", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("morro_badge", "diego-tcq")
      |> live(@path)

    assert has_element?(view, "#wrong-station", "Forbidden")
    assert has_element?(view, "#wrong-station", "TCQ")
    refute has_element?(view, "#morro-board")
  end
end
