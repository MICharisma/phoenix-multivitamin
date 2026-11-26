# Ecto queries and contexts · 03 · Singapore named bindings
#
# Teaches:
# - as: :flight and as: :airline named bindings
# - where: references the named airline binding, not position

defmodule PhoenixMultivitamin.SingaporeHubDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SingaporeFlight

  def list_flights_for_iata(iata) do
    Repo.all(
      from flight in SingaporeFlight,
        as: :flight,
        join: airline in assoc(flight, :singapore_airline),
        as: :airline,
        where: as(:airline).iata == ^iata,
        order_by: [asc: as(:flight).flight_number],
        select: %{
          flight_number: as(:flight).flight_number,
          destination: as(:flight).destination,
          gate: as(:flight).gate,
          airline: as(:airline).name
        }
    )
  end
end
