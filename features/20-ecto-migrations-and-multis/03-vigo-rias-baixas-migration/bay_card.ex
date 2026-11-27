# Ecto migrations and multis · 03 · Vigo Rías Baixas migration
#
# Teaches:
# - belongs_to matching the references/2 column

defmodule PhoenixMultivitamin.VigoBayCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "vigo_bay_cards" do
    field :clerk, :string
    field :craft, :string
    field :cargo_kg, :integer
    belongs_to :stand, PhoenixMultivitamin.VigoStand, foreign_key: :vigo_stand_id

    timestamps(type: :utc_datetime)
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :cargo_kg, :vigo_stand_id])
    |> validate_required([:clerk, :craft, :cargo_kg, :vigo_stand_id])
    |> validate_number(:cargo_kg, greater_than: 0)
    |> foreign_key_constraint(:vigo_stand_id)
  end
end
