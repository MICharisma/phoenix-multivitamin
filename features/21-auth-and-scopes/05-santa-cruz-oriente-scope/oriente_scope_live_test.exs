defmodule PhoenixMultivitaminWeb.SantaCruzOrienteScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.OrienteLedger
  alias PhoenixMultivitaminWeb.OrienteScope

  @path "/features/21-auth-and-scopes/05-santa-cruz-oriente-scope"

  test "Viru Viru scope shows only VVI shipments and their total", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("oriente_badge", "renata-vvi")
      |> live(@path)

    assert has_element?(view, "#scope-clerk", "Renata")
    assert has_element?(view, "#scope-station", "VVI")
    assert has_element?(view, "#shipment-soya-41")
    assert has_element?(view, "#shipment-beef-09")
    assert has_element?(view, "#shipment-timber-vvi")
    assert has_element?(view, "#ledger-total", "23350")

    refute has_element?(view, "#shipment-gas-lpb")
    refute has_element?(view, "#shipment-sugar-sre")
  end

  test "ledger queries never leak other stations" do
    scope = OrienteScope.for_renata()
    shipments = OrienteLedger.list_shipments(scope)

    assert OrienteLedger.stations_present(scope) == ["VVI"]
    assert Enum.all?(shipments, &(&1.station_id == "VVI"))
    refute Enum.any?(shipments, &(&1.station_id in ["LPB", "SRE"]))
    assert OrienteLedger.total_kg(scope) == 12_400 + 3_200 + 7_750
  end
end
