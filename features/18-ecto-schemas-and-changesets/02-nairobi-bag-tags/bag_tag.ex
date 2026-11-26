# Ecto schemas and changesets · 02 · Nairobi bag tag
#
# Teaches:
# - A nested embedded_schema for each tag on the load

defmodule PhoenixMultivitamin.NairobiBagTag do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :tag_code, :string
    field :weight_kg, :integer
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:tag_code, :weight_kg])
    |> validate_required([:tag_code, :weight_kg])
    |> validate_number(:weight_kg, greater_than: 0, less_than_or_equal_to: 32)
  end
end
