# Ecto migrations and multis · 11 · León Camino multi
#
# Teaches:
# - Leg schema for the first merged Multi

defmodule PhoenixMultivitamin.LeonCaminoLeg do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "leon_camino_legs" do
    field :clerk, :string
    field :craft, :string
    field :from_icao, :string
    field :to_icao, :string
    has_many :stamps, PhoenixMultivitamin.LeonCaminoStamp

    timestamps(type: :utc_datetime)
  end

  def changeset(leg, attrs) do
    leg
    |> cast(attrs, [:clerk, :craft, :from_icao, :to_icao])
    |> validate_required([:clerk, :craft, :from_icao, :to_icao])
  end
end
