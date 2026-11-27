# Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi
#
# Teaches:
# - Order schema for the first Multi.insert

defmodule PhoenixMultivitamin.SalamancaPlazaOrder do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "salamanca_plaza_orders" do
    field :clerk, :string
    field :craft, :string
    field :stand, :string
    has_many :lines, PhoenixMultivitamin.SalamancaPlazaLine

    timestamps(type: :utc_datetime)
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:clerk, :craft, :stand])
    |> validate_required([:clerk, :craft, :stand])
  end
end
