# Ecto queries and contexts · 13 · Doha composed desk
#
# Teaches:
# - Composable context functions that take and return queries
# - The LiveView only calls the public door; query internals stay private

defmodule PhoenixMultivitamin.DohaComposedDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.DohaLeg
  alias PhoenixMultivitamin.Repo

  def list_legs(filters) when is_map(filters) do
    DohaLeg
    |> base()
    |> with_airline(Map.get(filters, :airline))
    |> with_status(Map.get(filters, :status))
    |> with_min_cargo(Map.get(filters, :min_cargo_kg))
    |> ordered()
    |> Repo.all()
  end

  defp base(query) do
    from leg in query, as: :leg
  end

  defp with_airline(query, nil), do: query
  defp with_airline(query, ""), do: query

  defp with_airline(query, airline) when is_binary(airline) do
    from [leg: leg] in query, where: leg.airline == ^airline
  end

  defp with_status(query, nil), do: query
  defp with_status(query, ""), do: query

  defp with_status(query, status) when is_binary(status) do
    from [leg: leg] in query, where: leg.status == ^status
  end

  defp with_min_cargo(query, nil), do: query

  defp with_min_cargo(query, min_kg) when is_integer(min_kg) do
    from [leg: leg] in query, where: leg.cargo_kg >= ^min_kg
  end

  defp ordered(query) do
    from [leg: leg] in query, order_by: [asc: leg.destination, asc: leg.id]
  end
end
