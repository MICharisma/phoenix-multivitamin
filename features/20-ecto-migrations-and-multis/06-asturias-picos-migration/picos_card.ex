# Ecto migrations and multis · 06 · Asturias Picos migration
#
# Teaches:
# - Schema keeps legacy_phase so a replayed backfill can be shown

defmodule PhoenixMultivitamin.AsturiasPicosCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "asturias_picos_cards" do
    field :clerk, :string
    field :craft, :string
    field :legacy_phase, :string
    field :phase, :string, default: "unknown"

    timestamps(type: :utc_datetime)
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :legacy_phase, :phase])
    |> validate_required([:clerk, :craft])
  end
end
