# Ecto migrations and multis · 13 · Logroño Rioja handover
#
# Teaches:
# - Batch schema guarded by a unique batch_code index

defmodule PhoenixMultivitamin.LogronoRiojaBatch do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "logrono_rioja_batches" do
    field :clerk, :string
    field :craft, :string
    field :batch_code, :string
    field :status, :string, default: "open"
    field :sealed_at, :utc_datetime
    has_many :notes, PhoenixMultivitamin.LogronoRiojaNote

    timestamps(type: :utc_datetime)
  end

  def changeset(batch, attrs) do
    batch
    |> cast(attrs, [:clerk, :craft, :batch_code, :status, :sealed_at])
    |> validate_required([:clerk, :craft, :batch_code, :status])
    |> validate_inclusion(:status, ["open", "sealed"])
    |> unique_constraint(:batch_code)
  end
end
