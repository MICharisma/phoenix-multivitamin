defmodule PhoenixMultivitamin.Repo.Migrations.CreateFeature18EctoSchemaTables do
  use Ecto.Migration

  def change do
    create table(:entebbe_stations) do
      add :name, :string, null: false
      add :icao, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:entebbe_watches) do
      add :controller, :string, null: false
      add :window, :string, null: false
      add :entebbe_station_id, references(:entebbe_stations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:entebbe_watches, [:entebbe_station_id])

    create table(:lusaka_hold_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :hold_min, :integer, null: false
      add :burned_min, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:windhoek_friction_readings) do
      add :clerk, :string, null: false
      add :runway, :string, null: false
      add :friction, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:johannesburg_turnarounds) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:johannesburg_crew_legs) do
      add :role, :string, null: false
      add :name, :string, null: false

      add :johannesburg_turnaround_id,
          references(:johannesburg_turnarounds, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create index(:johannesburg_crew_legs, [:johannesburg_turnaround_id])

    create table(:antananarivo_designators) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :callsign, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:antananarivo_designators, [:callsign])

    create table(:mauritius_fuel_tickets) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :litres, :integer, null: false
      add :unit_hint, :string

      timestamps(type: :utc_datetime)
    end

    create table(:reunion_credential_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :hangar_code, :string, null: false
      add :access_token, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
