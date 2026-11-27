# Ecto migrations and multis · 13 · Logroño Rioja handover
#
# Teaches:
# - Note schema attached during the Multi

defmodule PhoenixMultivitamin.LogronoRiojaNote do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "logrono_rioja_notes" do
    field :body, :string
    belongs_to :batch, PhoenixMultivitamin.LogronoRiojaBatch, foreign_key: :logrono_rioja_batch_id

    timestamps(type: :utc_datetime)
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:body, :logrono_rioja_batch_id])
    |> validate_required([:body, :logrono_rioja_batch_id])
    |> validate_length(:body, min: 3)
  end
end
