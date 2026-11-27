defmodule PhoenixMultivitaminWeb.CasablancaRamDomainLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.CasablancaGettext

  @path "/features/24-gettext-translations/03-casablanca-ram-domain"

  test "dgettext resolves the gates domain separately from default", %{conn: conn} do
    Gettext.put_locale(CasablancaGettext, "fr")

    assert Gettext.dgettext(CasablancaGettext, "gates", "Gate open for boarding") ==
             "Porte ouverte pour l'embarquement"

    assert Gettext.gettext(CasablancaGettext, "Ramp clear for pushback") ==
             "Aire libre pour le repoussage"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "Aire libre pour le repoussage"

    html = render_click(element(view, "#gate-A12"))
    assert html =~ "Porte ouverte pour l&#39;embarquement"

    html = render_click(element(view, "#gate-Z99"))
    assert html =~ "Porte inconnue"
  end
end
