defmodule PhoenixMultivitaminWeb.MaputoCallsignValidateLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/09-maputo-callsign-validate"

  test "validate_change refuses a messy callsign and accepts LAM312", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Graça")

    view
    |> form("#ramp-card-form", ramp_card: %{callsign: "lam-312"})
    |> render_change()

    assert has_element?(view, "#ramp-card-form", "must look like an ICAO callsign")

    view
    |> form("#ramp-card-form", ramp_card: %{callsign: "LAM312"})
    |> render_submit()

    assert has_element?(view, "#accepted-callsign", "LAM312")
  end
end
