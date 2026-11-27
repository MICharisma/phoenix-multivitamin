# Ecto queries and contexts · 06 · Santiago late preload
#
# Teaches:
# - Manifest belongs_to airline

defmodule PhoenixMultivitamin.SantiagoManifest do
  @moduledoc false
  use Ecto.Schema

  schema "santiago_manifests" do
    field :clerk, :string
    field :craft, :string
    field :awb, :string
    field :kilograms, :integer
    belongs_to :santiago_airline, PhoenixMultivitamin.SantiagoAirline

    timestamps(type: :utc_datetime)
  end
end
