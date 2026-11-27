# Ecto migrations and multis · 11 · León Camino multi
#
# Teaches:
# - Stamp schema for the second merged Multi

defmodule PhoenixMultivitamin.LeonCaminoStamp do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "leon_camino_stamps" do
    field :stamp, :string
    belongs_to :leg, PhoenixMultivitamin.LeonCaminoLeg, foreign_key: :leon_camino_leg_id

    timestamps(type: :utc_datetime)
  end

  def changeset(stamp, attrs) do
    stamp
    |> cast(attrs, [:stamp, :leon_camino_leg_id])
    |> validate_required([:stamp, :leon_camino_leg_id])
  end
end
