# Ecto queries and contexts · 13 · Doha composed desk
#
# Teaches:
# - Leg schema for composable query functions

defmodule PhoenixMultivitamin.DohaLeg do
  @moduledoc false
  use Ecto.Schema

  schema "doha_legs" do
    field :clerk, :string
    field :craft, :string
    field :airline, :string
    field :destination, :string
    field :status, :string
    field :cargo_kg, :integer, default: 0

    timestamps(type: :utc_datetime)
  end
end
