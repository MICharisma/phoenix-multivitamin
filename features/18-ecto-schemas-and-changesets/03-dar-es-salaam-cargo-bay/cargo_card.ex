# Ecto schemas and changesets · 03 · Dar es Salaam cargo card
#
# Teaches:
# - embeds_one/3 with cast_embed required: true

defmodule PhoenixMultivitamin.DarCargoCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.DarCargoBay

  embedded_schema do
    field :clerk, :string
    field :craft, :string
    embeds_one :bay, DarCargoBay, on_replace: :update
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft])
    |> validate_required([:clerk, :craft])
    |> cast_embed(:bay, required: true)
  end
end
