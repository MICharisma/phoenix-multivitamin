# Ecto queries and contexts · 07 · Helsinki overdue cards
#
# Teaches:
# - Correlated exists subquery with parent_as/1
# - Outer query filters aircraft that still have overdue cards

defmodule PhoenixMultivitamin.HelsinkiOverdueDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.HelsinkiAircraft
  alias PhoenixMultivitamin.HelsinkiWorkCard
  alias PhoenixMultivitamin.Repo

  def list_aircraft_with_overdue_cards do
    overdue_exists =
      from card in HelsinkiWorkCard,
        where: parent_as(:aircraft).id == card.helsinki_aircraft_id,
        where: card.overdue == true,
        select: 1

    Repo.all(
      from aircraft in HelsinkiAircraft,
        as: :aircraft,
        where: exists(subquery(overdue_exists)),
        order_by: [asc: aircraft.registration],
        preload: :work_cards
    )
  end
end
