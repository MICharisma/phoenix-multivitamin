defmodule PhoenixMultivitaminWeb.TaupoBeaconReceiveLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/12-taupo-beacon-receive"

  test "pinging ash paints a volcanic tick on the board", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#empty-beacon")

    view |> element("#ping-ash") |> render_click()
    assert has_element?(view, "#beacon-ticks", "ash plume drifting east of the caldera")
    refute has_element?(view, "#empty-beacon")
  end
end
