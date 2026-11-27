defmodule PhoenixMultivitaminWeb.DohaComposedDeskLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.DohaLeg
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/13-doha-composed-desk"

  test "composable filters narrow legs through the context door", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    rows = [
      {"Qatar Airways", "Singapore", "boarding", 1200},
      {"Qatar Airways", "Athens", "boarding", 200},
      {"Qatar Airways", "Muscat", "departed", 800},
      {"Oman Air", "Muscat", "boarding", 900}
    ]

    for {airline, dest, status, kg} <- rows do
      {:ok, _} =
        Repo.insert(%DohaLeg{
          clerk: "Fatima",
          craft: "Airbus A350-1000",
          airline: airline,
          destination: dest,
          status: status,
          cargo_kg: kg,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#leg-count", "1")
    assert has_element?(view, "#composed-legs", "Singapore")
    refute has_element?(view, "#composed-legs", "Athens")
    refute has_element?(view, "#composed-legs", "Oman Air")

    view
    |> form("#compose-form", %{airline: "Qatar Airways", status: "", min_cargo_kg: "800"})
    |> render_change()

    assert has_element?(view, "#leg-count", "2")
    assert has_element?(view, "#composed-legs", "Singapore")
    assert has_element?(view, "#composed-legs", "Muscat")
    refute has_element?(view, "#composed-legs", "Athens")
  end
end
