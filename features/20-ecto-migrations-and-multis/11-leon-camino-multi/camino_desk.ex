# Ecto migrations and multis · 11 · León Camino multi
#
# Teaches:
# - Multi.merge/2 composes two smaller Multis
# - Map.fetch!/2 reads the merged leg before stamping

defmodule PhoenixMultivitamin.LeonCaminoDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.LeonCaminoLeg
  alias PhoenixMultivitamin.LeonCaminoStamp
  alias PhoenixMultivitamin.Repo

  def walk_leg(from_icao, to_icao, stamp)
      when is_binary(from_icao) and is_binary(to_icao) and is_binary(stamp) do
    Multi.new()
    |> Multi.merge(fn _changes -> leg_multi(from_icao, to_icao) end)
    |> Multi.merge(fn changes ->
      leg = Map.fetch!(changes, :leg)
      stamp_multi(leg, stamp)
    end)
    |> Repo.transaction()
  end

  defp leg_multi(from_icao, to_icao) do
    Multi.new()
    |> Multi.insert(
      :leg,
      LeonCaminoLeg.changeset(%LeonCaminoLeg{}, %{
        clerk: "Froilán",
        craft: "Pilatus PC-12",
        from_icao: from_icao,
        to_icao: to_icao
      })
    )
  end

  defp stamp_multi(leg, stamp) do
    Multi.new()
    |> Multi.insert(
      :stamp,
      LeonCaminoStamp.changeset(%LeonCaminoStamp{}, %{
        stamp: stamp,
        leon_camino_leg_id: leg.id
      })
    )
  end
end
