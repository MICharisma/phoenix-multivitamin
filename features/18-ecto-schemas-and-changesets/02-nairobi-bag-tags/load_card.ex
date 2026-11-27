# Ecto schemas and changesets · 02 · Nairobi load card
#
# Teaches:
# - embeds_many/3 with cast_embed/3 for a list of bag tags

defmodule PhoenixMultivitamin.NairobiLoadCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.NairobiBagTag

  embedded_schema do
    field :clerk, :string
    field :craft, :string
    embeds_many :bag_tags, NairobiBagTag, on_replace: :delete
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft])
    |> validate_required([:clerk, :craft])
    |> cast_embed(:bag_tags, required: true)
    |> validate_tag_count()
  end

  defp validate_tag_count(changeset) do
    tags = get_field(changeset, :bag_tags) || []

    if length(tags) >= 1 do
      changeset
    else
      add_error(changeset, :bag_tags, "need at least one tag")
    end
  end
end
