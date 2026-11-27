# Ecto queries and contexts · 02 · Dubai cargo holds
#
# Teaches:
# - Schema for sealed hold rows

defmodule PhoenixMultivitamin.DubaiCargoHold do
  @moduledoc false
  use Ecto.Schema

  schema "dubai_cargo_holds" do
    field :clerk, :string
    field :craft, :string
    field :hold_code, :string
    field :kilograms, :integer
    field :sealed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end
end
