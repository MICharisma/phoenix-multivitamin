defmodule PhoenixMultivitaminWeb.DubaiEmiratesContextLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.DubaiGettext

  @path "/features/24-gettext-translations/04-dubai-emirates-context"

  test "pgettext disambiguates open for gate versus stand", %{conn: conn} do
    Gettext.put_locale(DubaiGettext, "ar")

    assert Gettext.pgettext(DubaiGettext, "gate state", "open") == "مفتوحة"
    assert Gettext.pgettext(DubaiGettext, "stand state", "open") == "شاغر"

    {:ok, view, _html} = live(conn, @path)
    assert render_click(element(view, "#paint-gate")) =~ "مفتوحة"
    assert render_click(element(view, "#paint-stand")) =~ "شاغر"
  end
end
