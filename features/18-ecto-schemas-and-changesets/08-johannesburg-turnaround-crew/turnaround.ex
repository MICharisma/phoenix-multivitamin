# Ecto schemas and changesets · 08 · Johannesburg turnaround
#
# Teaches:
# - cast_assoc/3 writing nested crew legs with the parent

defmodule PhoenixMultivitamin.JohannesburgTurnaround do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.JohannesburgCrewLeg

  schema "johannesburg_turnarounds" do
    field :clerk, :string
    field :craft, :string
    field :stand, :string
    has_many :crew_legs, JohannesburgCrewLeg, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(turnaround, attrs) do
    turnaround
    |> cast(attrs, [:clerk, :craft, :stand])
    |> validate_required([:clerk, :craft, :stand])
    |> cast_assoc(:crew_legs, required: true)
  end
end
