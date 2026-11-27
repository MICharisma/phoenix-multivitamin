# Ecto queries and contexts · 05 · Tokyo join preload
#
# Teaches:
# - Crew belongs_to airline

defmodule PhoenixMultivitamin.TokyoCrew do
  @moduledoc false
  use Ecto.Schema

  schema "tokyo_crews" do
    field :clerk, :string
    field :craft, :string
    field :role, :string
    belongs_to :tokyo_airline, PhoenixMultivitamin.TokyoAirline

    timestamps(type: :utc_datetime)
  end
end
