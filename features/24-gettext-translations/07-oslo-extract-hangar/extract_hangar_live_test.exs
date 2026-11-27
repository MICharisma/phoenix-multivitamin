defmodule PhoenixMultivitaminWeb.OsloExtractHangarLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.OsloGettext

  @path "/features/24-gettext-translations/07-oslo-extract-hangar"
  @pot "priv/gettext_24/07-oslo-extract-hangar/default.pot"
  @po "priv/gettext_24/07-oslo-extract-hangar/nb/LC_MESSAGES/default.po"

  test "extracted pot and merged po carry the hangar msgids", %{conn: conn} do
    pot = File.read!(@pot)
    po = File.read!(@po)

    assert pot =~ ~s|msgid "Hangar bay clear"|
    assert pot =~ ~s|msgid "Plate stamped for inspection"|
    assert po =~ ~s|msgid "Hangar bay clear"|
    assert po =~ ~s|msgstr "Hangarbukt klar"|

    Gettext.put_locale(OsloGettext, "nb")

    assert Gettext.gettext(OsloGettext, "Hangar bay clear") == "Hangarbukt klar"

    assert Gettext.gettext(OsloGettext, "Plate stamped for inspection") ==
             "Plate stemplet for inspeksjon"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "Hangarbukt klar"
    assert html =~ "LN-NIE"
    assert render_click(element(view, "#stamp-plate")) =~ "Plate stemplet for inspeksjon"
  end
end
