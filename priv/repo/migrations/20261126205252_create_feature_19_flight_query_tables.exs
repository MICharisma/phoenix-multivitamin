defmodule PhoenixMultivitamin.Repo.Migrations.CreateFeature19FlightQueryTables do
  use Ecto.Migration

  def change do
    create table(:reykjavik_crew_assignments) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :role, :string, null: false
      add :posted, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create table(:dubai_cargo_holds) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :hold_code, :string, null: false
      add :kilograms, :integer, null: false
      add :sealed, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create table(:singapore_airlines) do
      add :name, :string, null: false
      add :iata, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:singapore_flights) do
      add :flight_number, :string, null: false
      add :destination, :string, null: false
      add :gate, :string, null: false

      add :singapore_airline_id, references(:singapore_airlines, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:singapore_flights, [:singapore_airline_id])

    create table(:johannesburg_bay_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :bay, :string, null: false
      add :status, :string, null: false
      add :open_defects, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create table(:tokyo_airlines) do
      add :name, :string, null: false
      add :iata, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:tokyo_crews) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :role, :string, null: false
      add :tokyo_airline_id, references(:tokyo_airlines, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tokyo_crews, [:tokyo_airline_id])

    create table(:santiago_airlines) do
      add :name, :string, null: false
      add :iata, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:santiago_manifests) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :awb, :string, null: false
      add :kilograms, :integer, null: false

      add :santiago_airline_id, references(:santiago_airlines, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:santiago_manifests, [:santiago_airline_id])

    create table(:helsinki_aircraft) do
      add :registration, :string, null: false
      add :craft, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:helsinki_work_cards) do
      add :title, :string, null: false
      add :overdue, :boolean, null: false, default: false

      add :helsinki_aircraft_id, references(:helsinki_aircraft, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:helsinki_work_cards, [:helsinki_aircraft_id])

    create table(:quito_cargo_tags) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :label, :string, null: false
      add :altitude_ft, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:nairobi_shipments) do
      add :clerk, :string, null: false
      add :airline, :string, null: false
      add :destination, :string, null: false
      add :kilograms, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:lisbon_delays) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :airline, :string, null: false
      add :minutes, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:auckland_apron_stands) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false
      add :occupied, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create table(:buenos_aires_ledger_lines) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :entry, :string, null: false
      add :litres, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:doha_legs) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :airline, :string, null: false
      add :destination, :string, null: false
      add :status, :string, null: false
      add :cargo_kg, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
