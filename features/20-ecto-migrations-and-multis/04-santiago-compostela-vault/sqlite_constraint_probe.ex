# Ecto migrations and multis · 04 · Santiago Compostela vault
#
# Teaches:
# - ecto_sqlite3 refuses create constraint DDL (ALTER TABLE ADD CONSTRAINT)

defmodule PhoenixMultivitamin.SantiagoSqliteConstraintProbe do
  @moduledoc false

  def try_add_check_constraint do
    constraint = %Ecto.Migration.Constraint{
      table: :santiago_vault_tickets,
      name: :litres_positive,
      check: "litres > 0"
    }

    Ecto.Adapters.SQLite3.Connection.execute_ddl({:create, constraint})
    :added
  rescue
    e in ArgumentError ->
      {:refused, Exception.message(e)}
  end
end
