defmodule PhoenixMultivitaminWeb.ReykjavikHoldShortLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.ReykjavikGettext

  @path "/features/24-gettext-translations/01-reykjavik-hold-short"

  test "gettext paints the Icelandic hold-short line", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Sigríður"
    assert html =~ "Locale is"
    assert has_element?(view, "#paint-hold")

    html = render_click(element(view, "#paint-hold"))
    assert html =~ "Bíddu stutt fyrir braut 13"

    assert Gettext.gettext(ReykjavikGettext, "Hold short of runway 13") ==
             "Bíddu stutt fyrir braut 13"
  end
end
