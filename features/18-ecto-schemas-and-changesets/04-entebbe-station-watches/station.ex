# Ecto schemas and changesets · 04 · Entebbe station
#
# Teaches:
# - schema/2 with has_many/3 for the night watches

defmodule PhoenixMultivitamin.EntebbeStation do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.EntebbeWatch

  schema "entebbe_stations" do
    field :name, :string
    field :icao, :string
    has_many :watches, EntebbeWatch

    timestamps(type: :utc_datetime)
  end

  def changeset(station, attrs) do
    station
    |> cast(attrs, [:name, :icao])
    |> validate_required([:name, :icao])
    |> validate_length(:icao, is: 4)
  end
end
