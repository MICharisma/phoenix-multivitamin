# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - Multi lives only inside the context; the LiveView never builds one
# - Context returns an enforced result struct, not raw Multi changes

defmodule PhoenixMultivitamin.VitoriaBasqueDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.VitoriaBasqueHandover
  alias PhoenixMultivitamin.VitoriaBasqueReceipt
  alias PhoenixMultivitamin.VitoriaHandoverResult

  def hand_over(bay, souls) when is_binary(bay) and is_integer(souls) do
    receipt_code = "VIT-" <> String.upcase(String.slice(bay, 0, 3)) <> "-#{souls}"

    Multi.new()
    |> Multi.insert(
      :handover,
      VitoriaBasqueHandover.changeset(%VitoriaBasqueHandover{}, %{
        clerk: "Amaia",
        craft: "ATR 42-600",
        bay: bay,
        souls: souls
      })
    )
    |> Multi.insert(:receipt, fn %{handover: handover} ->
      VitoriaBasqueReceipt.changeset(%VitoriaBasqueReceipt{}, %{
        receipt_code: receipt_code,
        vitoria_basque_handover_id: handover.id
      })
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{handover: handover, receipt: receipt}} ->
        {:ok,
         %VitoriaHandoverResult{
           bay: handover.bay,
           receipt_code: receipt.receipt_code,
           souls: handover.souls
         }}

      {:error, step, value, changes} ->
        {:error, step, value, changes}
    end
  end
end
