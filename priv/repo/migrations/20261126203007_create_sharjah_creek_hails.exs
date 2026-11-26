defmodule PhoenixMultivitamin.Repo.Migrations.CreateSharjahCreekHails do
  use Ecto.Migration

  def change do
    create table(:sharjah_creek_hails) do
      add :callsign, :string, null: false
      add :reporting_point, :string, null: false
      add :altitude_ft, :integer, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
