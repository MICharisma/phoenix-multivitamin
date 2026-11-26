defmodule PhoenixMultivitaminWeb.RiyadhWithLocaleLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.RiyadhGettext

  @path "/features/24-gettext-translations/10-riyadh-with-locale"

  test "with_locale restores Arabic after an English brief", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Fahad"
    assert has_element?(view, "#outer-locale", "ar")

    html = render_click(element(view, "#paint-desk"))
    assert html =~ "توقف قبل ممر برافو"
    assert html =~ "Hold short of taxiway Bravo"
    assert has_element?(view, "#restored-locale", "ar")

    assert Gettext.get_locale(RiyadhGettext) in ["ar", "en"]
  end

  test "nested with_locale returns to the outer Arabic locale", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    html = render_click(element(view, "#nested-brief"))
    assert html =~ "مصرح بالهبوط على المدرج 33L"
    assert html =~ "Cleared to land runway 33L"
    assert has_element?(view, "#nested-locale", "ar")
  end
end
