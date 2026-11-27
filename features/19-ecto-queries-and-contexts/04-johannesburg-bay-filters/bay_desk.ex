# Ecto queries and contexts · 04 · Johannesburg bay filters
#
# Teaches:
# - dynamic/2 builds optional where clauses
# - Enum.reduce folds filters into one dynamic

defmodule PhoenixMultivitamin.JohannesburgBayDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.JohannesburgBayCard
  alias PhoenixMultivitamin.Repo

  def list_bay_cards(filters) when is_map(filters) do
    JohannesburgBayCard
    |> where(^filter_dynamic(filters))
    |> order_by([card], asc: card.bay, asc: card.id)
    |> Repo.all()
  end

  defp filter_dynamic(filters) do
    Enum.reduce(filters, dynamic(true), fn
      {:bay, bay}, dynamic when is_binary(bay) and bay != "" ->
        dynamic([card], ^dynamic and card.bay == ^bay)

      {:status, status}, dynamic when is_binary(status) and status != "" ->
        dynamic([card], ^dynamic and card.status == ^status)

      {:min_defects, min}, dynamic when is_integer(min) ->
        dynamic([card], ^dynamic and card.open_defects >= ^min)

      _other, dynamic ->
        dynamic
    end)
  end
end
