# Ecto queries and contexts · 01 · Reykjavik crew board
#
# Teaches:
# - Keyword from/where/order_by stays inside the context
# - The LiveView never touches Repo or Ecto.Query

defmodule PhoenixMultivitamin.ReykjavikCrewBoard do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.ReykjavikCrewAssignment
  alias PhoenixMultivitamin.Repo

  def list_posted_assignments do
    Repo.all(
      from assignment in ReykjavikCrewAssignment,
        where: assignment.posted == true,
        order_by: [asc: assignment.role, asc: assignment.id],
        select: assignment
    )
  end
end
