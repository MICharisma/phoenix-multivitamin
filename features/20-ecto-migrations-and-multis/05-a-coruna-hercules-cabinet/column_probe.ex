# Ecto migrations and multis · 05 · A Coruña Hercules cabinet
#
# Teaches:
# - A defstruct reports pragma columns
# - SQLite rejects NOT NULL without DEFAULT on a populated table

defmodule PhoenixMultivitamin.ACorunaColumnProbe do
  @moduledoc false

  defstruct [:name, :notnull, :dflt_value]

  alias PhoenixMultivitamin.Repo

  def columns(table) when is_binary(table) do
    %{rows: rows} = Ecto.Adapters.SQL.query!(Repo, "PRAGMA table_info(#{table})")

    for [_cid, name, _type, notnull, dflt, _pk] <- rows do
      %__MODULE__{name: name, notnull: notnull == 1, dflt_value: dflt}
    end
  end

  def try_add_not_null_without_default(table, column)
      when is_binary(table) and is_binary(column) do
    sql = "ALTER TABLE #{table} ADD COLUMN #{column} TEXT NOT NULL"

    case Ecto.Adapters.SQL.query(Repo, sql) do
      {:ok, _} -> :added
      {:error, %{message: message}} -> {:refused, message}
      {:error, reason} -> {:refused, inspect(reason)}
    end
  end
end
