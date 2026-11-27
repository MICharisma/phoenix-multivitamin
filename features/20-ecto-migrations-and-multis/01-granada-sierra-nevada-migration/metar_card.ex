# Ecto migrations and multis · 01 · Granada Sierra Nevada migration
#
# Teaches:
# - The schema matches the reversible change/0 table

defmodule PhoenixMultivitamin.GranadaMetarCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "granada_metar_cards" do
    field :clerk, :string
    field :craft, :string
    field :visibility_m, :integer
    field :runway, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :visibility_m, :runway])
    |> validate_required([:clerk, :craft, :visibility_m, :runway])
    |> validate_number(:visibility_m, greater_than: 0)
  end
end
