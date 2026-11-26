# Ecto schemas and changesets · 08 · Johannesburg crew leg
#
# Teaches:
# - Child schema for cast_assoc under a turnaround

defmodule PhoenixMultivitamin.JohannesburgCrewLeg do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixMultivitamin.JohannesburgTurnaround

  schema "johannesburg_crew_legs" do
    field :role, :string
    field :name, :string
    belongs_to :johannesburg_turnaround, JohannesburgTurnaround

    timestamps(type: :utc_datetime)
  end

  def changeset(leg, attrs) do
    leg
    |> cast(attrs, [:role, :name])
    |> validate_required([:role, :name])
    |> validate_inclusion(:role, ~w(captain first_officer cabin_lead))
  end
end
