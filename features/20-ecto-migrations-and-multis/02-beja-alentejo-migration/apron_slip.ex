# Ecto migrations and multis · 02 · Beja Alentejo migration
#
# Teaches:
# - Schema for the table that up/0 creates

defmodule PhoenixMultivitamin.BejaApronSlip do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "beja_apron_slips" do
    field :clerk, :string
    field :craft, :string
    field :stand, :string
    field :chocks_on, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(slip, attrs) do
    slip
    |> cast(attrs, [:clerk, :craft, :stand, :chocks_on])
    |> validate_required([:clerk, :craft, :stand])
  end
end
