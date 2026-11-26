# Ecto queries and contexts · 07 · Helsinki overdue cards
#
# Teaches:
# - Aircraft parent for exists subquery

defmodule PhoenixMultivitamin.HelsinkiAircraft do
  @moduledoc false
  use Ecto.Schema

  schema "helsinki_aircraft" do
    field :registration, :string
    field :craft, :string
    has_many :work_cards, PhoenixMultivitamin.HelsinkiWorkCard

    timestamps(type: :utc_datetime)
  end
end
