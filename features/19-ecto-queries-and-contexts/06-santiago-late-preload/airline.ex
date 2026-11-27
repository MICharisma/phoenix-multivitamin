# Ecto queries and contexts · 06 · Santiago late preload
#
# Teaches:
# - Airline parent for Repo.preload/2 after fetch

defmodule PhoenixMultivitamin.SantiagoAirline do
  @moduledoc false
  use Ecto.Schema

  schema "santiago_airlines" do
    field :name, :string
    field :iata, :string
    has_many :manifests, PhoenixMultivitamin.SantiagoManifest

    timestamps(type: :utc_datetime)
  end
end
