# Ecto queries and contexts · 10 · Lisbon delay ranks
#
# Teaches:
# - Delay row schema for window ranking

defmodule PhoenixMultivitamin.LisbonDelay do
  @moduledoc false
  use Ecto.Schema

  schema "lisbon_delays" do
    field :clerk, :string
    field :craft, :string
    field :airline, :string
    field :minutes, :integer

    timestamps(type: :utc_datetime)
  end
end
