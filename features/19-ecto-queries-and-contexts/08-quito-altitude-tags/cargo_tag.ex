# Ecto queries and contexts · 08 · Quito altitude tags
#
# Teaches:
# - Cargo tag schema for fragment filters

defmodule PhoenixMultivitamin.QuitoCargoTag do
  @moduledoc false
  use Ecto.Schema

  schema "quito_cargo_tags" do
    field :clerk, :string
    field :craft, :string
    field :label, :string
    field :altitude_ft, :integer

    timestamps(type: :utc_datetime)
  end
end
