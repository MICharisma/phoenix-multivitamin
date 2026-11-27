# Ecto migrations and multis · 02 · Beja Alentejo migration
#
# Teaches:
# - up/0 and down/0 when change/0 is not enough
# - create index/2 in up, drop_if_exists in down

defmodule PhoenixMultivitamin.BejaApronSlipsMigration do
  @moduledoc false
  use Ecto.Migration

  def up do
    create table(:beja_apron_slips) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false
      add :chocks_on, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create index(:beja_apron_slips, [:stand])
  end

  def down do
    drop_if_exists index(:beja_apron_slips, [:stand])
    drop table(:beja_apron_slips)
  end
end
