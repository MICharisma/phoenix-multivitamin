# Ecto migrations and multis · 07 · Santander Cantabria multi
#
# Teaches:
# - Fuel slip schema for the second Multi.insert

defmodule PhoenixMultivitamin.SantanderFuelSlip do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "santander_fuel_slips" do
    field :litres, :integer

    belongs_to :manifest, PhoenixMultivitamin.SantanderManifest,
      foreign_key: :santander_manifest_id

    timestamps(type: :utc_datetime)
  end

  def changeset(slip, attrs) do
    slip
    |> cast(attrs, [:litres, :santander_manifest_id])
    |> validate_required([:litres, :santander_manifest_id])
    |> validate_number(:litres, greater_than: 0)
  end
end
