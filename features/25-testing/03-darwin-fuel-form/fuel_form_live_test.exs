defmodule PhoenixMultivitaminWeb.DarwinFuelFormLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/25-testing/03-darwin-fuel-form"

  test "render_change paints the litres error beside the input", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Jedda")

    view
    |> form("#fuel-slip-form", fuel_slip: %{litres: "5000", bay: "north"})
    |> render_change()

    assert has_element?(view, "#fuel-slip-form", "must be less than or equal to 3200")
  end

  test "form/3 plus render_submit posts a valid Top End slip", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#fuel-slip-form", fuel_slip: %{litres: "1800", bay: "south"})
    |> render_submit()

    assert has_element?(view, "#posted-slip", "1800 L on the south bay")
  end
end
