defmodule PhoenixMultivitaminWeb.MoscowSheremetyevoPluralsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MoscowGettext

  @path "/features/24-gettext-translations/08-moscow-sheremetyevo-plurals"

  test "Russian ngettext covers 1, few, many, and 21", %{conn: conn} do
    Gettext.put_locale(MoscowGettext, "ru")
    msgid = "1 free stand"
    plural = "%{count} free stands"

    assert Gettext.ngettext(MoscowGettext, msgid, plural, 1) == "1 свободное место"
    assert Gettext.ngettext(MoscowGettext, msgid, plural, 2) == "2 свободных места"
    assert Gettext.ngettext(MoscowGettext, msgid, plural, 5) == "5 свободных мест"
    assert Gettext.ngettext(MoscowGettext, msgid, plural, 21) == "21 свободное место"
    assert Gettext.ngettext(MoscowGettext, msgid, plural, 22) == "22 свободных места"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "1 свободное место"
    assert html =~ "21 свободное место"
    assert render_click(element(view, "#spotlight-5")) =~ "5 свободных мест"
  end
end
