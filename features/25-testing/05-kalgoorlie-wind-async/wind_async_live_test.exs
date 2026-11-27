defmodule PhoenixMultivitaminWeb.KalgoorlieWindAsyncLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/05-kalgoorlie-wind-async"

  test "the disconnected mount keeps Goldfields wind quiet", %{conn: conn} do
    html = html_response(get(conn, @path), 200)
    assert html =~ "Kalgoorlie wind async"
    assert html =~ "Tarni"
    assert html =~ "Static mount. Goldfields wind waits for the socket."
    refute html =~ "27018G26KT"
  end

  test "render_async fills the wind on the connected mount", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Tarni"
    html = render_async(view)
    assert html =~ "27018G26KT"
    assert has_element?(view, "#wind-value", "27018G26KT")
    assert has_element?(view, "#craft-name", "King Air 350")
    refute has_element?(view, "#wind-loading")
  end
end
