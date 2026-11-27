# Testing · 08 · Dunedin fuel ledger
#
# Teaches:
# - A context module is the only door tests use to reach the Repo
# - Enum.reduce/3 totals litres by bay

defmodule PhoenixMultivitamin.DunedinFuelLedger do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.DunedinFuelEntry
  alias PhoenixMultivitamin.Repo

  def post_entry(attrs) when is_map(attrs) do
    %DunedinFuelEntry{}
    |> DunedinFuelEntry.changeset(attrs)
    |> Repo.insert()
  end

  def litres_by_bay do
    DunedinFuelEntry
    |> group_by([entry], entry.bay)
    |> select([entry], {entry.bay, sum(entry.litres)})
    |> Repo.all()
    |> Map.new()
  end

  def total_litres(entries) when is_list(entries) do
    Enum.reduce(entries, 0, fn %DunedinFuelEntry{litres: litres}, acc -> acc + litres end)
  end
end
