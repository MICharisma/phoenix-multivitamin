# Ecto queries and contexts · 11 · Auckland apron count
#
# Teaches:
# - Repo.aggregate/3 for a count on a filtered query
# - No structs loaded; only the aggregate returns

defmodule PhoenixMultivitamin.AucklandApronDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.AucklandApronStand
  alias PhoenixMultivitamin.Repo

  def occupied_stand_count do
    AucklandApronStand
    |> where([stand], stand.occupied == true)
    |> Repo.aggregate(:count)
  end

  def free_stand_count do
    AucklandApronStand
    |> where([stand], stand.occupied == false)
    |> Repo.aggregate(:count, :id)
  end
end
