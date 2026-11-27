# Telemetry and LiveDashboard · 10 · Beira Sofala duration
#
# Teaches:
# - Ecto emits [:phoenix_multivitamin, :repo, :query] with total_time and query_time
# - with/1 branches a Repo.query/1 result; columns are pattern-matched from the result

defmodule PhoenixMultivitaminWeb.BeiraSofalaDuration do
  @moduledoc false

  alias PhoenixMultivitamin.Repo

  @event [:phoenix_multivitamin, :repo, :query]

  def event_name, do: @event

  def run_ping do
    with {:ok, result} <- Repo.query("SELECT 1 AS sofala_ping") do
      decode_ping(result)
    end
  end

  defp decode_ping(%{columns: columns, rows: rows}) do
    case {columns, rows} do
      {["sofala_ping"], [[value]]} ->
        {:ok, %{column: "sofala_ping", value: value, harbour: "Beira", province: "Sofala"}}

      {other_columns, other_rows} ->
        {:error, {:unexpected_shape, other_columns, other_rows}}
    end
  end
end
