# Ecto migrations and multis · 07 · Santander Cantabria multi
#
# Teaches:
# - Ecto.Multi.insert/3 then insert/3 sharing the first result
# - Repo.transaction/1 runs the whole multi

defmodule PhoenixMultivitamin.SantanderCantabriaDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantanderFuelSlip
  alias PhoenixMultivitamin.SantanderManifest

  def file_pair(destination, litres) when is_binary(destination) and is_integer(litres) do
    Multi.new()
    |> Multi.insert(
      :manifest,
      SantanderManifest.changeset(%SantanderManifest{}, %{
        clerk: "Itziar",
        craft: "Boeing 737-800",
        destination: destination
      })
    )
    |> Multi.insert(:fuel_slip, fn %{manifest: manifest} ->
      SantanderFuelSlip.changeset(%SantanderFuelSlip{}, %{
        litres: litres,
        santander_manifest_id: manifest.id
      })
    end)
    |> Repo.transaction()
  end
end
