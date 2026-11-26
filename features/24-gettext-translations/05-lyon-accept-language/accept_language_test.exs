defmodule PhoenixMultivitaminWeb.LyonAcceptLanguageTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.LyonGettext

  @map "/features/24-gettext-translations/05-lyon-accept-language"
  @atis "/features/24-gettext-translations/05-lyon-accept-language/atis"

  test "Accept-Language fr paints the French ATIS line", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept-language", "fr-FR,fr;q=0.9,en;q=0.8")
      |> get(@atis)

    html = html_response(conn, 200)
    assert html =~ "fr"
    assert html =~ "accept_language"
    assert html =~ "ATIS information Alpha disponible"
    assert conn.assigns.locale == "fr"
  end

  test "Accept-Language de picks German when listed first by q", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept-language", "de;q=0.9,en;q=0.5")
      |> get(@atis)

    html = html_response(conn, 200)
    assert html =~ "ATIS-Information Alpha verfügbar"
    assert conn.assigns.locale == "de"
  end

  test "unsupported Accept-Language falls back to English", %{conn: conn} do
    Gettext.put_locale(LyonGettext, "en")

    conn =
      conn
      |> put_req_header("accept-language", "ja;q=1.0")
      |> get(@atis)

    html = html_response(conn, 200)
    assert html =~ "ATIS information Alpha available"
    assert conn.assigns.locale == "en"
  end

  test "the catalog map links onto the ATIS desk", %{conn: conn} do
    {:ok, _view, html} = live(conn, @map)
    assert html =~ "Camille"
    assert html =~ ~s|href="#{@atis}"|
  end
end
