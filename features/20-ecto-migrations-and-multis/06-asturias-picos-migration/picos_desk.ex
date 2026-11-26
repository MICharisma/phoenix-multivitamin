# Ecto migrations and multis · 06 · Asturias Picos migration
#
# Teaches:
# - A context replays the same SQL the migration's execute/2 runs
# - Enum.frequencies_by/2 tallies phases after the backfill

defmodule PhoenixMultivitamin.AsturiasPicosDesk do
  @moduledoc false

  alias PhoenixMultivitamin.AsturiasPicosCard
  alias PhoenixMultivitamin.Repo

  def seed_legacy!(cards) when is_list(cards) do
    Enum.map(cards, fn attrs ->
      %AsturiasPicosCard{}
      |> AsturiasPicosCard.changeset(Map.put(attrs, :phase, "unknown"))
      |> Repo.insert!()
    end)
  end

  def replay_backfill! do
    {:ok, _} =
      Ecto.Adapters.SQL.query(
        Repo,
        "UPDATE asturias_picos_cards SET phase = legacy_phase WHERE legacy_phase IS NOT NULL"
      )

    :ok
  end

  def phase_tallies do
    AsturiasPicosCard
    |> Repo.all()
    |> Enum.frequencies_by(& &1.phase)
  end
end
