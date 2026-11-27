# Ecto queries and contexts · 09 · Nairobi cargo totals
#
# Teaches:
# - Shipment schema for group_by aggregates

defmodule PhoenixMultivitamin.NairobiShipment do
  @moduledoc false
  use Ecto.Schema

  schema "nairobi_shipments" do
    field :clerk, :string
    field :airline, :string
    field :destination, :string
    field :kilograms, :integer

    timestamps(type: :utc_datetime)
  end
end
