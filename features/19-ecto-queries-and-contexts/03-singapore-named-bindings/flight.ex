# Ecto queries and contexts · 03 · Singapore named bindings
#
# Teaches:
# - Flight belongs_to airline for as: joins

defmodule PhoenixMultivitamin.SingaporeFlight do
  @moduledoc false
  use Ecto.Schema

  schema "singapore_flights" do
    field :flight_number, :string
    field :destination, :string
    field :gate, :string
    belongs_to :singapore_airline, PhoenixMultivitamin.SingaporeAirline

    timestamps(type: :utc_datetime)
  end
end
