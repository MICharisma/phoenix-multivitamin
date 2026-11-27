# Ecto migrations and multis · 06 · Asturias Picos migration
#
# Teaches:
# - execute/2 supplies reversible up and down SQL for a data backfill
# - execute/1 alone inside change/0 cannot be reversed

defmodule PhoenixMultivitamin.AsturiasPicosMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:asturias_picos_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :legacy_phase, :string
      add :phase, :string, null: false, default: "unknown"

      timestamps(type: :utc_datetime)
    end

    execute(
      "UPDATE asturias_picos_cards SET phase = legacy_phase WHERE legacy_phase IS NOT NULL",
      "UPDATE asturias_picos_cards SET phase = 'unknown' WHERE legacy_phase IS NOT NULL"
    )
  end
end
