# Ecto migrations and multis · 03 · Vigo Rías Baixas migration
#
# Teaches:
# - references/2 with on_delete: :delete_all
# - create index/2 on the foreign key column

defmodule PhoenixMultivitamin.VigoRiasBaixasMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:vigo_stands) do
      add :label, :string, null: false
      add :harbour, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:vigo_bay_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :cargo_kg, :integer, null: false
      add :vigo_stand_id, references(:vigo_stands, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:vigo_bay_cards, [:vigo_stand_id])
  end
end
