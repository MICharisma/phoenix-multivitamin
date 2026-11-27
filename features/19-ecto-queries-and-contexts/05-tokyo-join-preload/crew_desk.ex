# Ecto queries and contexts · 05 · Tokyo join preload
#
# Teaches:
# - join: + preload: [tokyo_airline: airline] in one query
# - Association loaded from the join binding, not a second SELECT

defmodule PhoenixMultivitamin.TokyoCrewDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.TokyoCrew

  def list_crews_with_airline do
    Repo.all(
      from crew in TokyoCrew,
        join: airline in assoc(crew, :tokyo_airline),
        preload: [tokyo_airline: airline],
        order_by: [asc: crew.role, asc: crew.id]
    )
  end
end
