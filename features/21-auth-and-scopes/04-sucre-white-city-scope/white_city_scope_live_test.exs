defmodule PhoenixMultivitaminWeb.SucreWhiteCityScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.WhiteCityBoards
  alias PhoenixMultivitaminWeb.WhiteCityScope

  @path "/features/21-auth-and-scopes/04-sucre-white-city-scope"

  test "Mateo's SRE scope lists only Sucre fuel slips", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("white_city_badge", "mateo-sre")
      |> live(@path)

    assert has_element?(view, "#scope-clerk", "Mateo")
    assert has_element?(view, "#scope-station", "SRE")
    assert has_element?(view, "#slip-jet-a1")
    assert has_element?(view, "#slip-avgas-12")
    refute has_element?(view, "#slip-jet-vvi")
    refute has_element?(view, "#empty-slips")
  end

  test "a foreign station scope returns an empty slip list", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("white_city_badge", "VVI")
      |> live(@path)

    assert has_element?(view, "#scope-station", "VVI")
    assert has_element?(view, "#empty-slips")
    refute has_element?(view, "#slip-jet-a1")
  end

  test "context heads filter and raise by station" do
    sre = WhiteCityScope.for_mateo()
    vvi = WhiteCityScope.for_station("VVI")

    assert length(WhiteCityBoards.list_slips(sre)) == 2
    assert WhiteCityBoards.list_slips(vvi) == []

    assert %{id: "jet-a1"} = WhiteCityBoards.get_slip!(sre, "jet-a1")

    assert_raise ArgumentError, ~r/station VVI cannot open/, fn ->
      WhiteCityBoards.get_slip!(vvi, "jet-a1")
    end
  end
end
