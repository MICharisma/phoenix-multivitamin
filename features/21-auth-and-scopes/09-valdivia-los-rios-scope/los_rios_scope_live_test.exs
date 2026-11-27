defmodule PhoenixMultivitaminWeb.ValdiviaLosRiosScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.LosRiosScope
  alias PhoenixMultivitaminWeb.LosRiosTokens

  @path "/features/21-auth-and-scopes/09-valdivia-los-rios-scope"

  test "mint_login_token and redeem_login_token build a LosRiosScope" do
    token = LosRiosTokens.mint_login_token("Pascual")

    assert {:ok, %LosRiosScope{clerk: "Pascual", station: "ZAL", token: ^token}} =
             LosRiosTokens.redeem_login_token(token)

    assert {:error, :invalid_token} = LosRiosTokens.redeem_login_token("not-a-token")
  end

  test "session los_rios_token becomes current_scope without current_user", %{conn: conn} do
    token = LosRiosTokens.mint_login_token("Pascual")

    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("los_rios_token", token)
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Pascual")
    assert has_element?(view, "#scope-clerk", "Pascual")
    assert has_element?(view, "#scope-station", "ZAL")
    assert has_element?(view, "#assign-keys", "current_scope")
    refute has_element?(view, "#assign-keys", "current_user")
    refute has_element?(view, "#fog-locked")
  end

  test "guest board stays locked until a fog link is redeemed", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#fog-locked")
    refute has_element?(view, "#estuary-board")

    view |> element("#mint-fog-link") |> render_click()
    html = render(view)
    assert html =~ "mint-fog-link"

    token = LosRiosTokens.mint_login_token("Pascual")

    view
    |> form("#redeem-fog-form", %{token: token})
    |> render_submit()

    assert has_element?(view, "#scope-clerk", "Pascual")
    assert has_element?(view, "#redeem-status", "redeemed")
    assert has_element?(view, "#assign-keys", "current_scope")
    refute has_element?(view, "#assign-keys", "current_user")
  end
end
