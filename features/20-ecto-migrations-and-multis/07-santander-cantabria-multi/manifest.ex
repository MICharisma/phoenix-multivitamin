# Ecto migrations and multis · 07 · Santander Cantabria multi
#
# Teaches:
# - Manifest schema for the first Multi.insert

defmodule PhoenixMultivitamin.SantanderManifest do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "santander_manifests" do
    field :clerk, :string
    field :craft, :string
    field :destination, :string
    has_one :fuel_slip, PhoenixMultivitamin.SantanderFuelSlip

    timestamps(type: :utc_datetime)
  end

  def changeset(manifest, attrs) do
    manifest
    |> cast(attrs, [:clerk, :craft, :destination])
    |> validate_required([:clerk, :craft, :destination])
  end
end
