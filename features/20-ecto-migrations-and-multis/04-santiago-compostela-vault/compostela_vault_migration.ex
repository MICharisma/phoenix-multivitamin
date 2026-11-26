# Ecto migrations and multis · 04 · Santiago Compostela vault
#
# Teaches:
# - unique_index/3 on vault_code
# - create constraint/3 check is rejected by SQLite (ALTER TABLE ADD CONSTRAINT)

defmodule PhoenixMultivitamin.SantiagoCompostelaVaultMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:santiago_vault_tickets) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :vault_code, :string, null: false
      add :litres, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:santiago_vault_tickets, [:vault_code])

    # SQLite cannot ALTER TABLE ADD CONSTRAINT. This call is the lesson:
    # ecto_sqlite3 raises ArgumentError. Put CHECK inside CREATE TABLE instead,
    # or enforce litres in the changeset with validate_number/3.
    create constraint(:santiago_vault_tickets, :litres_positive, check: "litres > 0")
  end
end
