# Testing · 08 · Dunedin fuel entry
#
# Teaches:
# - The schema lives with the scenario
# - DataCase opens the SQL sandbox around every Repo write

defmodule PhoenixMultivitamin.DunedinFuelEntry do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "dunedin_fuel_entries" do
    field :clerk, :string
    field :craft, :string
    field :litres, :integer
    field :bay, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(entry \\ %__MODULE__{}, attrs) do
    entry
    |> cast(attrs, [:clerk, :craft, :litres, :bay])
    |> validate_required([:clerk, :craft, :litres, :bay])
    |> validate_number(:litres, greater_than: 0)
    |> validate_inclusion(:bay, ~w(otago harbour))
  end
end
