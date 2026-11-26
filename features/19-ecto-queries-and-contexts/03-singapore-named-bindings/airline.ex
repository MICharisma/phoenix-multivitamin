# Ecto queries and contexts · 03 · Singapore named bindings
#
# Teaches:
# - Parent airline for named-binding joins

defmodule PhoenixMultivitamin.SingaporeAirline do
  @moduledoc false
  use Ecto.Schema

  schema "singapore_airlines" do
    field :name, :string
    field :iata, :string
    has_many :flights, PhoenixMultivitamin.SingaporeFlight

    timestamps(type: :utc_datetime)
  end
end
