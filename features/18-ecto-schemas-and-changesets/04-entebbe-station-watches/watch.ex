# Ecto schemas and changesets · 04 · Entebbe watch
#
# Teaches:
# - belongs_to/3 tying a watch to its station

defmodule PhoenixMultivitamin.EntebbeWatch do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.EntebbeStation

  schema "entebbe_watches" do
    field :controller, :string
    field :window, :string
    belongs_to :entebbe_station, EntebbeStation

    timestamps(type: :utc_datetime)
  end

  def changeset(watch, attrs) do
    watch
    |> cast(attrs, [:controller, :window, :entebbe_station_id])
    |> validate_required([:controller, :window, :entebbe_station_id])
    |> foreign_key_constraint(:entebbe_station_id)
  end
end
