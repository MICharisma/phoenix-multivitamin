# Ecto queries and contexts · 11 · Auckland apron count
#
# Teaches:
# - Apron stand schema for Repo.aggregate

defmodule PhoenixMultivitamin.AucklandApronStand do
  @moduledoc false
  use Ecto.Schema

  schema "auckland_apron_stands" do
    field :clerk, :string
    field :craft, :string
    field :stand, :string
    field :occupied, :boolean, default: false

    timestamps(type: :utc_datetime)
  end
end
