# Ecto queries and contexts · 10 · Lisbon delay ranks
#
# Teaches:
# - over(row_number(), partition_by: ..., order_by: ...)
# - Window ranks delays per airline without collapsing rows

defmodule PhoenixMultivitamin.LisbonDelayRanks do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.LisbonDelay
  alias PhoenixMultivitamin.Repo

  def ranked_delays do
    ranked =
      from delay in LisbonDelay,
        windows: [
          airline_rank: [
            partition_by: delay.airline,
            order_by: [desc: delay.minutes, asc: delay.id]
          ]
        ],
        select: %{
          id: delay.id,
          airline: delay.airline,
          craft: delay.craft,
          minutes: delay.minutes,
          rank: over(row_number(), :airline_rank)
        }

    Repo.all(from row in subquery(ranked), order_by: [asc: row.airline, asc: row.rank])
  end
end
