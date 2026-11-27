# Ecto queries and contexts · 01 · Reykjavik crew board
#
# Teaches:
# - Schema lives with the scenario
# - Keyword from/2 is the listing door

defmodule PhoenixMultivitamin.ReykjavikCrewAssignment do
  @moduledoc false
  use Ecto.Schema

  schema "reykjavik_crew_assignments" do
    field :clerk, :string
    field :craft, :string
    field :role, :string
    field :posted, :boolean, default: false

    timestamps(type: :utc_datetime)
  end
end
