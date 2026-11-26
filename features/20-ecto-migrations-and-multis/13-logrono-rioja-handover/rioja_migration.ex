# Ecto migrations and multis · 13 · Logroño Rioja handover
#
# Teaches:
# - Capstone migration: unique_index on batch_code plus the notes table

defmodule PhoenixMultivitamin.LogronoRiojaMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:logrono_rioja_batches) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :batch_code, :string, null: false
      add :status, :string, null: false, default: "open"
      add :sealed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:logrono_rioja_batches, [:batch_code])

    create table(:logrono_rioja_notes) do
      add :body, :string, null: false

      add :logrono_rioja_batch_id, references(:logrono_rioja_batches, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:logrono_rioja_notes, [:logrono_rioja_batch_id])
  end
end
