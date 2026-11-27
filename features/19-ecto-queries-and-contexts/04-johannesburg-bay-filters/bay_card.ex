# Ecto queries and contexts · 04 · Johannesburg bay filters
#
# Teaches:
# - Maintenance bay card schema

defmodule PhoenixMultivitamin.JohannesburgBayCard do
  @moduledoc false
  use Ecto.Schema

  schema "johannesburg_bay_cards" do
    field :clerk, :string
    field :craft, :string
    field :bay, :string
    field :status, :string
    field :open_defects, :integer, default: 0

    timestamps(type: :utc_datetime)
  end
end
