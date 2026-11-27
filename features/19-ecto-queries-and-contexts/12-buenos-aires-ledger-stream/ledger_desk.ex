# Ecto queries and contexts · 12 · Buenos Aires ledger stream
#
# Teaches:
# - Repo.stream/2 inside Repo.transaction/2
# - Stream reduces without loading the whole ledger into a list first

defmodule PhoenixMultivitamin.BuenosAiresLedgerDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.BuenosAiresLedgerLine
  alias PhoenixMultivitamin.Repo

  def sum_litres_in_transaction do
    query =
      BuenosAiresLedgerLine
      |> order_by([line], asc: line.id)
      |> select([line], line.litres)

    {:ok, total} =
      Repo.transaction(fn ->
        query
        |> Repo.stream(max_rows: 2)
        |> Enum.reduce(0, fn litres, acc -> acc + litres end)
      end)

    total
  end

  def open_litres_stream do
    BuenosAiresLedgerLine
    |> select([line], line.litres)
    |> Repo.stream()
  end

  def stream_outside_transaction! do
    open_litres_stream()
    |> Enum.reduce(0, fn litres, acc -> acc + litres end)
  end
end
