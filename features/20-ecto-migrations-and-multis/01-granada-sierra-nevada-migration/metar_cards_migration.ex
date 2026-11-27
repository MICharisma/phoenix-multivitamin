# Ecto migrations and multis · 01 · Granada Sierra Nevada migration
#
# Teaches:
# - change/0 that Ecto can reverse automatically
# - create table/2 with null: false columns and utc_datetime timestamps

defmodule PhoenixMultivitamin.GranadaMetarCardsMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:granada_metar_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :visibility_m, :integer, null: false
      add :runway, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
