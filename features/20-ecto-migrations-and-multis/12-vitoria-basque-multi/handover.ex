# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - Handover schema written only through the context Multi

defmodule PhoenixMultivitamin.VitoriaBasqueHandover do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "vitoria_basque_handovers" do
    field :clerk, :string
    field :craft, :string
    field :bay, :string
    field :souls, :integer
    has_one :receipt, PhoenixMultivitamin.VitoriaBasqueReceipt

    timestamps(type: :utc_datetime)
  end

  def changeset(handover, attrs) do
    handover
    |> cast(attrs, [:clerk, :craft, :bay, :souls])
    |> validate_required([:clerk, :craft, :bay, :souls])
    |> validate_number(:souls, greater_than: 0)
  end
end
