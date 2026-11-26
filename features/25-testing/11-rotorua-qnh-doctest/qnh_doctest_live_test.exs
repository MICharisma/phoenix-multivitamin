defmodule PhoenixMultivitaminWeb.RotoruaQnhDoctestLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/11-rotorua-qnh-doctest"

  test "the catalog form labels a steam-field QNH", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#qnh-form", qnh: "1013")
    |> render_submit()

    assert has_element?(view, "#qnh-label", "QNH 1013 · steam field")
  end
end
