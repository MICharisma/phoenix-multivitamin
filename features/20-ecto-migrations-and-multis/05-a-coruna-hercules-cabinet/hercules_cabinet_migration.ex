# Ecto migrations and multis · 05 · A Coruña Hercules cabinet
#
# Teaches:
# - alter table/2 adding a column with a default
# - Why SQLite refuses NOT NULL without a default on a non-empty table

defmodule PhoenixMultivitamin.ACorunaHerculesCabinetMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:coruna_hercules_cabinets) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :beacon, :string, null: false

      timestamps(type: :utc_datetime)
    end

    alter table(:coruna_hercules_cabinets) do
      add :lamp_hours, :integer, null: false, default: 0
    end
  end
end
