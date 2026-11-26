defmodule PhoenixMultivitaminWeb.NairobiCargoTotalsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.NairobiShipment
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/09-nairobi-cargo-totals"

  test "group_by having keeps airlines at or above 3000 kg", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    rows = [
      {"Kenya Airways Cargo", "Mombasa", 1800},
      {"Kenya Airways Cargo", "Kisumu", 1400},
      {"Ethiopian Cargo", "Addis Ababa", 2500},
      {"RwandAir Cargo", "Kigali", 900}
    ]

    for {airline, dest, kg} <- rows do
      {:ok, _} =
        Repo.insert(%NairobiShipment{
          clerk: "Wanjiku",
          airline: airline,
          destination: dest,
          kilograms: kg,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#airline-count", "1")
    assert has_element?(view, "#cargo-totals", "Kenya Airways Cargo")
    assert has_element?(view, "#cargo-totals", "3200 kg")
    refute has_element?(view, "#cargo-totals", "Ethiopian Cargo")
    refute has_element?(view, "#cargo-totals", "RwandAir Cargo")
  end
end
