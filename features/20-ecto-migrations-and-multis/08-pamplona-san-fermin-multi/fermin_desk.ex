# Ecto migrations and multis · 08 · Pamplona San Fermín multi
#
# Teaches:
# - Multi.run/3 for a step that is not a schema write
# - The run callback receives prior named changes

defmodule PhoenixMultivitamin.PamplonaFerminDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.PamplonaPlate
  alias PhoenixMultivitamin.Repo

  def stamp_plate(stand, litres) when is_binary(stand) and is_integer(litres) and litres > 0 do
    Multi.new()
    |> Multi.insert(
      :plate,
      PamplonaPlate.changeset(%PamplonaPlate{}, %{
        clerk: "Ainhoa",
        craft: "Embraer E190",
        stand: stand,
        litres: litres
      })
    )
    |> Multi.run(:gate_fee, fn _repo, %{plate: plate} ->
      fee = gate_fee_for(plate.litres)
      {:ok, fee}
    end)
    |> Multi.update(:plated, fn %{plate: plate, gate_fee: fee} ->
      PamplonaPlate.changeset(plate, %{gate_fee_eur: fee})
    end)
    |> Repo.transaction()
  end

  def stamp_plate(_stand, litres) when is_integer(litres) and litres <= 0 do
    {:error, :litres_not_positive}
  end

  defp gate_fee_for(litres) when litres < 3000, do: 120
  defp gate_fee_for(litres) when litres < 6000, do: 240
  defp gate_fee_for(_litres), do: 360
end
