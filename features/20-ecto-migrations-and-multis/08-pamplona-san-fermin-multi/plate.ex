# Ecto migrations and multis · 08 · Pamplona San Fermín multi
#
# Teaches:
# - Plate schema; gate_fee_eur is filled by Multi.run

defmodule PhoenixMultivitamin.PamplonaPlate do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "pamplona_plates" do
    field :clerk, :string
    field :craft, :string
    field :stand, :string
    field :litres, :integer
    field :gate_fee_eur, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(plate, attrs) do
    plate
    |> cast(attrs, [:clerk, :craft, :stand, :litres, :gate_fee_eur])
    |> validate_required([:clerk, :craft, :stand, :litres])
    |> validate_number(:litres, greater_than: 0)
  end
end
