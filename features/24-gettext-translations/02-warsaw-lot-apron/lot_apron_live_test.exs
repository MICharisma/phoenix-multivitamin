defmodule PhoenixMultivitaminWeb.WarsawLotApronLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.WarsawGettext

  @path "/features/24-gettext-translations/02-warsaw-lot-apron"

  test "Polish ngettext uses three plural forms on the Chopin apron", %{conn: conn} do
    Gettext.put_locale(WarsawGettext, "pl")

    assert Gettext.ngettext(
             WarsawGettext,
             "1 aircraft on the apron",
             "%{count} aircraft on the apron",
             1
           ) == "1 samolot na płycie"

    assert Gettext.ngettext(
             WarsawGettext,
             "1 aircraft on the apron",
             "%{count} aircraft on the apron",
             2
           ) == "2 samoloty na płycie"

    assert Gettext.ngettext(
             WarsawGettext,
             "1 aircraft on the apron",
             "%{count} aircraft on the apron",
             5
           ) == "5 samolotów na płycie"

    assert Gettext.ngettext(
             WarsawGettext,
             "1 aircraft on the apron",
             "%{count} aircraft on the apron",
             22
           ) == "22 samoloty na płycie"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "1 samolot na płycie"
    assert html =~ "2 samoloty na płycie"
    assert html =~ "5 samolotów na płycie"

    html = render_click(element(view, "#tally-22"))
    assert html =~ "22 samoloty na płycie"
  end
end
