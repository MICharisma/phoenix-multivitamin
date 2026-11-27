# Ecto queries and contexts · 07 · Helsinki overdue cards
#
# Teaches:
# - Work card belongs_to aircraft

defmodule PhoenixMultivitamin.HelsinkiWorkCard do
  @moduledoc false
  use Ecto.Schema

  schema "helsinki_work_cards" do
    field :title, :string
    field :overdue, :boolean, default: false
    belongs_to :helsinki_aircraft, PhoenixMultivitamin.HelsinkiAircraft

    timestamps(type: :utc_datetime)
  end
end
