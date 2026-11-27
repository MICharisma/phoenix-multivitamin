defmodule PhoenixMultivitaminWeb.SingaporeNamedBindingsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SingaporeAirline
  alias PhoenixMultivitamin.SingaporeFlight

  @path "/features/19-ecto-queries-and-contexts/03-singapore-named-bindings"

  test "named bindings filter flights by airline IATA", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, sq} =
      Repo.insert(%SingaporeAirline{
        name: "Singapore Airlines",
        iata: "SQ",
        inserted_at: now,
        updated_at: now
      })

    {:ok, mh} =
      Repo.insert(%SingaporeAirline{
        name: "Malaysia Airlines",
        iata: "MH",
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%SingaporeFlight{
        flight_number: "SQ318",
        destination: "London Heathrow",
        gate: "A12",
        singapore_airline_id: sq.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%SingaporeFlight{
        flight_number: "SQ976",
        destination: "Jakarta",
        gate: "B4",
        singapore_airline_id: sq.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%SingaporeFlight{
        flight_number: "MH608",
        destination: "Kuala Lumpur",
        gate: "C1",
        singapore_airline_id: mh.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#flight-count", "2")
    assert has_element?(view, "#named-flights", "SQ318")
    assert has_element?(view, "#named-flights", "SQ976")
    refute has_element?(view, "#named-flights", "MH608")
  end
end
