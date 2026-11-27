# Ecto schemas and changesets · 01 · Addis Ababa gate plate
#
# Teaches:
# - embedded_schema/1 with typed fields and no table behind it

defmodule PhoenixMultivitamin.AddisGatePlate do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :clerk, :string
    field :craft, :string
    field :gate, :string
    field :souls, :integer
    field :pushback_at, :utc_datetime
  end

  def changeset(plate, attrs) do
    plate
    |> cast(attrs, [:clerk, :craft, :gate, :souls, :pushback_at])
    |> validate_required([:clerk, :craft, :gate, :souls])
    |> validate_number(:souls, greater_than: 0)
  end
end
