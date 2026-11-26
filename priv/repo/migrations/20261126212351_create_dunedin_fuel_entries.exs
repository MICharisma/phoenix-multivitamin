defmodule PhoenixMultivitamin.Repo.Migrations.CreateDunedinFuelEntries do
  use Ecto.Migration

  def change do
    create table(:dunedin_fuel_entries) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :litres, :integer, null: false
      add :bay, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:dunedin_fuel_entries, [:bay])
  end
end
