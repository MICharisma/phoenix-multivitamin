# Ecto migrations and multis · 05 · A Coruña Hercules cabinet
#
# Teaches:
# - Schema includes the column that alter added

defmodule PhoenixMultivitamin.ACorunaHerculesCabinet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "coruna_hercules_cabinets" do
    field :clerk, :string
    field :craft, :string
    field :beacon, :string
    field :lamp_hours, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(cabinet, attrs) do
    cabinet
    |> cast(attrs, [:clerk, :craft, :beacon, :lamp_hours])
    |> validate_required([:clerk, :craft, :beacon])
    |> validate_number(:lamp_hours, greater_than_or_equal_to: 0)
  end
end
