defmodule PhoenixMultivitaminWeb.KrakowFallbackMsgidLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.KrakowGettext

  @path "/features/24-gettext-translations/11-krakow-fallback-msgid"

  test "missing msgstr falls back to the msgid", %{conn: conn} do
    Gettext.put_locale(KrakowGettext, "pl")

    assert Gettext.gettext(KrakowGettext, "De-ice pad open") == "Płyta odladzania otwarta"

    assert Gettext.gettext(KrakowGettext, "Snow NOTAM pending review") ==
             "Snow NOTAM pending review"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "Płyta odladzania otwarta"
    assert html =~ "Snow NOTAM pending review"
    assert has_element?(view, "#deice-line[data-fallback=false]")
    assert has_element?(view, "#notam-line[data-fallback=true]")

    html = render_click(element(view, "#classify"))
    assert html =~ "de-ice translated; NOTAM fell back to msgid"
  end
end
