# Ecto migrations and multis · 13 · Logroño Rioja handover
#
# Teaches:
# - Capstone context Multi: insert, run, update, and a note insert
# - Unique batch_code short-circuits with the failed step named

defmodule PhoenixMultivitamin.LogronoRiojaDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.LogronoRiojaBatch
  alias PhoenixMultivitamin.LogronoRiojaNote
  alias PhoenixMultivitamin.Repo

  def seal_batch(batch_code, note_body)
      when is_binary(batch_code) and is_binary(note_body) do
    sealed_at = DateTime.utc_now() |> DateTime.truncate(:second)

    Multi.new()
    |> Multi.insert(
      :batch,
      LogronoRiojaBatch.changeset(%LogronoRiojaBatch{}, %{
        clerk: "Laia",
        craft: "Bombardier CRJ900",
        batch_code: batch_code,
        status: "open"
      })
    )
    |> Multi.run(:seal_clock, fn _repo, %{batch: _batch} ->
      {:ok, sealed_at}
    end)
    |> Multi.update(:sealed_batch, fn %{batch: batch, seal_clock: at} ->
      LogronoRiojaBatch.changeset(batch, %{status: "sealed", sealed_at: at})
    end)
    |> Multi.insert(:note, fn %{sealed_batch: batch} ->
      LogronoRiojaNote.changeset(%LogronoRiojaNote{}, %{
        body: note_body,
        logrono_rioja_batch_id: batch.id
      })
    end)
    |> Repo.transaction()
  end
end
