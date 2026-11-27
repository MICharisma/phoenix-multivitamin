# Ecto schemas and changesets · 12 · Mahé NOTAM draft
#
# Teaches:
# - Schemaless changesets: types map + cast/4 with no schema module

defmodule PhoenixMultivitamin.MaheNotamDraft do
  @moduledoc false
  import Ecto.Changeset

  @types %{
    clerk: :string,
    craft: :string,
    icao: :string,
    body: :string,
    valid_hours: :integer
  }

  def changeset(attrs) when is_map(attrs) do
    {%{}, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:clerk, :craft, :icao, :body, :valid_hours])
    |> validate_length(:icao, is: 4)
    |> validate_length(:body, min: 12, max: 280)
    |> validate_number(:valid_hours, greater_than: 0, less_than_or_equal_to: 72)
  end

  def types, do: @types
end
