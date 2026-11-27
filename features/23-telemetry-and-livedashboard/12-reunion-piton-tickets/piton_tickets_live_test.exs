defmodule PhoenixMultivitaminWeb.ReunionPitonTicketsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.ReunionPitonTicketsPage

  @path "/features/23-telemetry-and-livedashboard/12-reunion-piton-tickets"
  @dashboard "/dev/dashboard/piton_tickets"

  test "menu_link enables a stocked board and disables an empty one" do
    tickets = ReunionPitonTicketsPage.default_tickets()

    assert {:ok, "Piton tickets"} =
             ReunionPitonTicketsPage.menu_link(%{tickets: tickets}, %{})

    assert {:disabled, "Piton tickets"} =
             ReunionPitonTicketsPage.menu_link(%{tickets: []}, %{})
  end

  test "the catalog board releases a ticket and links the dashboard page", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Roland Garros"
    assert has_element?(view, "#menu-enabled", "Piton tickets")
    assert has_element?(view, "#menu-disabled", "Piton tickets")
    assert has_element?(view, "#open-piton-dashboard")
    assert has_element?(view, "#status-UU974", "open")

    view |> element("#release-UU974") |> render_click()
    assert has_element?(view, "#status-UU974", "cleared")
  end

  test "LiveDashboard serves the Piton page when dev routes are on", %{conn: conn} do
    {:ok, view, _html} = live(conn, @dashboard)
    html = render(view)

    assert html =~ "Piton de la Fournaise"
    assert html =~ "UU974"
    assert html =~ "Ash drift over Roland Garros"
  end
end
