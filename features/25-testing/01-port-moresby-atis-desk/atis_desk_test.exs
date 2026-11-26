defmodule PhoenixMultivitaminWeb.PortMoresbyAtisDeskTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @map "/features/25-testing/01-port-moresby-atis-desk"
  @atis @map <> "/atis"
  @export @map <> "/atis/export"

  test "the catalog page links the HTML board and the JSON export", %{conn: conn} do
    {:ok, view, _html} = live(conn, @map)
    assert has_element?(view, "#open-atis")
    assert has_element?(view, "#export-atis")
    assert has_element?(view, "#clerk-name", "Kila")
  end

  test "show/2 renders the ATIS as HTML", %{conn: conn} do
    conn = get(conn, @atis)
    html = html_response(conn, 200)
    assert html =~ "AYPY"
    assert html =~ "Kila"
    assert html =~ "14012KT"
    assert html =~ "Dash 8-200"
  end

  test "export/2 returns the same ATIS as JSON without the HTML view", %{conn: conn} do
    conn = get(conn, @export)
    body = json_response(conn, 200)
    assert body["format"] == "json"
    assert body["atis"]["station"] == "AYPY"
    assert body["atis"]["observer"] == "Kila"
    assert body["atis"]["information"] == "Charlie"
    refute html_response_like?(conn)
  end

  defp html_response_like?(conn) do
    conn.resp_body =~ "<html"
  end
end
