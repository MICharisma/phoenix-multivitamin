# Ecto queries and contexts · 02 · Dubai cargo holds
#
# Teaches:
# - Pipe syntax: schema |> where |> order_by |> Repo.all
# - Same job as keyword from, different code shape

defmodule PhoenixMultivitamin.DubaiCargoHolds do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.DubaiCargoHold
  alias PhoenixMultivitamin.Repo

  def list_sealed_holds do
    DubaiCargoHold
    |> where([hold], hold.sealed == true)
    |> order_by([hold], asc: hold.hold_code)
    |> select([hold], hold)
    |> Repo.all()
  end
end
