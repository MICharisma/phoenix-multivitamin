defmodule PhoenixMultivitaminWeb.SaoPauloPutLocaleLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/24-gettext-translations/06-sao-paulo-put-locale"

  test "put_locale from the query paints Portuguese by default", %{conn: conn} do
    {:ok, _view, html} = live(conn, @path)
    assert html =~ "Autorizado para o pushback em Congonhas"
    assert html =~ "Márcia"
  end

  test "patching locale=en switches the pushback line", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    html = render_patch(view, @path <> "?locale=en")
    assert html =~ "Cleared for pushback at Congonhas"
    assert has_element?(view, "#locale", "en")
  end

  test "an unsupported locale is rejected and Portuguese stays", %{conn: conn} do
    {:ok, view, html} = live(conn, @path <> "?locale=ja")
    assert html =~ "Autorizado para o pushback em Congonhas"
    assert has_element?(view, "#rejected-locale", "ja")
  end
end
