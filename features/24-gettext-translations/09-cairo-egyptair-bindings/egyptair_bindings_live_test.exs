defmodule PhoenixMultivitaminWeb.CairoEgyptairBindingsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import ExUnit.CaptureLog
  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.CairoGettext

  @path "/features/24-gettext-translations/09-cairo-egyptair-bindings"

  test "bindings interpolate flight and stand into Arabic", %{conn: conn} do
    Gettext.put_locale(CairoGettext, "ar")

    assert Gettext.gettext(CairoGettext, "Flight %{flight} to stand %{stand}", %{
             flight: "MS780",
             stand: "C4"
           }) == "رحلة MS780 إلى موقف C4"

    {:ok, view, html} = live(conn, @path)
    assert html =~ "رحلة MS780 إلى موقف C4"
    assert html =~ "رحلة MS802 إلى موقف B9"

    html = render_click(element(view, "#activate-MS780"))
    assert html =~ "رحلة MS780 إلى موقف C4"

    {html, log} =
      with_log(fn ->
        render_click(element(view, "#broken-bindings"))
      end)

    assert html =~ "رحلة %{flight} إلى موقف %{stand}"
    assert log =~ "missing Gettext bindings"
  end
end
