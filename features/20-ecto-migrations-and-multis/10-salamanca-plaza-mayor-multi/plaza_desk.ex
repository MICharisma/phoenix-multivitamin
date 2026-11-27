# Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi
#
# Teaches:
# - A failed second step short-circuits the Multi
# - Inspect failed_operation, failed_value, and changes_so_far

defmodule PhoenixMultivitamin.SalamancaPlazaDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SalamancaPlazaLine
  alias PhoenixMultivitamin.SalamancaPlazaOrder

  def place_order(stand, part, qty)
      when is_binary(stand) and is_binary(part) and is_integer(qty) do
    Multi.new()
    |> Multi.insert(
      :order,
      SalamancaPlazaOrder.changeset(%SalamancaPlazaOrder{}, %{
        clerk: "Jimena",
        craft: "Cessna Citation CJ4",
        stand: stand
      })
    )
    |> Multi.insert(:line, fn %{order: order} ->
      SalamancaPlazaLine.changeset(%SalamancaPlazaLine{}, %{
        part: part,
        qty: qty,
        salamanca_plaza_order_id: order.id
      })
    end)
    |> Repo.transaction()
    |> summarise()
  end

  defp summarise({:ok, changes}) do
    {:ok, changes}
  end

  defp summarise({:error, failed_operation, failed_value, changes_so_far}) do
    {:error,
     %{
       failed_operation: failed_operation,
       failed_value: failed_value,
       changes_so_far: changes_so_far,
       order_persisted?:
         case changes_so_far do
           %{order: %{id: id}} -> not is_nil(Repo.get(SalamancaPlazaOrder, id))
           _ -> false
         end
     }}
  end
end
