# Ecto schemas and changesets · 06 · Windhoek friction reading
#
# Teaches:
# - Wiring a custom Ecto.Type into a schema field

defmodule PhoenixMultivitamin.WindhoekFrictionReading do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.WindhoekFrictionCode

  schema "windhoek_friction_readings" do
    field :clerk, :string
    field :runway, :string
    field :friction, WindhoekFrictionCode

    timestamps(type: :utc_datetime)
  end

  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:clerk, :runway, :friction])
    |> validate_required([:clerk, :runway, :friction])
    |> validate_length(:runway, max: 8)
  end
end
