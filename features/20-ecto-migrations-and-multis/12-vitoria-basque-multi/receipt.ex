# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - Receipt schema with unique receipt_code

defmodule PhoenixMultivitamin.VitoriaBasqueReceipt do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "vitoria_basque_receipts" do
    field :receipt_code, :string

    belongs_to :handover, PhoenixMultivitamin.VitoriaBasqueHandover,
      foreign_key: :vitoria_basque_handover_id

    timestamps(type: :utc_datetime)
  end

  def changeset(receipt, attrs) do
    receipt
    |> cast(attrs, [:receipt_code, :vitoria_basque_handover_id])
    |> validate_required([:receipt_code, :vitoria_basque_handover_id])
    |> unique_constraint(:receipt_code)
  end
end
