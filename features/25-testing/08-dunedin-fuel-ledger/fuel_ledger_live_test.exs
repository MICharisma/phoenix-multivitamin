defmodule PhoenixMultivitaminWeb.DunedinFuelLedgerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.DunedinFuelLedger

  @path "/features/25-testing/08-dunedin-fuel-ledger"

  test "the LiveView posts Otago fuel through the sandbox", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#otago-total", "0")

    view |> element("#post-otago") |> render_click()
    assert has_element?(view, "#otago-total", "2400")
    assert DunedinFuelLedger.litres_by_bay() == %{"otago" => 2_400}
  end
end
