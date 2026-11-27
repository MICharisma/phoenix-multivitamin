# Ecto schemas and changesets · 10 · Antananarivo designator
#
# Teaches:
# - unique_constraint/3 surfaces only after Repo.insert hits the index

defmodule PhoenixMultivitamin.AntananarivoDesignator do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "antananarivo_designators" do
    field :clerk, :string
    field :craft, :string
    field :callsign, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(designator, attrs) do
    designator
    |> cast(attrs, [:clerk, :craft, :callsign])
    |> validate_required([:clerk, :craft, :callsign])
    |> validate_length(:callsign, min: 4, max: 8)
    |> unique_constraint(:callsign)
  end
end
