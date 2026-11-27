# Ecto queries and contexts · 05 · Tokyo join preload
#
# Teaches:
# - Airline parent for join-preload

defmodule PhoenixMultivitamin.TokyoAirline do
  @moduledoc false
  use Ecto.Schema

  schema "tokyo_airlines" do
    field :name, :string
    field :iata, :string
    has_many :crews, PhoenixMultivitamin.TokyoCrew

    timestamps(type: :utc_datetime)
  end
end
