defmodule PhoenixMultivitamin.Repo.Migrations.CreateFeature20MigrationMultiTables do
  use Ecto.Migration

  def change do
    create table(:granada_metar_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :visibility_m, :integer, null: false
      add :runway, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:beja_apron_slips) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false
      add :chocks_on, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create index(:beja_apron_slips, [:stand])

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

    create table(:santiago_vault_tickets) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :vault_code, :string, null: false
      add :litres, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:santiago_vault_tickets, [:vault_code])

    create table(:coruna_hercules_cabinets) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :beacon, :string, null: false
      add :lamp_hours, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create table(:asturias_picos_cards) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :legacy_phase, :string
      add :phase, :string, null: false, default: "unknown"

      timestamps(type: :utc_datetime)
    end

    create table(:santander_manifests) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :destination, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:santander_fuel_slips) do
      add :litres, :integer, null: false

      add :santander_manifest_id, references(:santander_manifests, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:santander_fuel_slips, [:santander_manifest_id])

    create table(:pamplona_plates) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false
      add :litres, :integer, null: false
      add :gate_fee_eur, :integer

      timestamps(type: :utc_datetime)
    end

    create table(:zaragoza_ebro_drafts) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :route, :string, null: false
      add :status, :string, null: false, default: "draft"

      timestamps(type: :utc_datetime)
    end

    create table(:salamanca_plaza_orders) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :stand, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:salamanca_plaza_lines) do
      add :part, :string, null: false
      add :qty, :integer, null: false

      add :salamanca_plaza_order_id, references(:salamanca_plaza_orders, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:salamanca_plaza_lines, [:salamanca_plaza_order_id])

    create table(:leon_camino_legs) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :from_icao, :string, null: false
      add :to_icao, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:leon_camino_stamps) do
      add :stamp, :string, null: false
      add :leon_camino_leg_id, references(:leon_camino_legs, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:leon_camino_stamps, [:leon_camino_leg_id])

    create table(:vitoria_basque_handovers) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :bay, :string, null: false
      add :souls, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:vitoria_basque_receipts) do
      add :receipt_code, :string, null: false

      add :vitoria_basque_handover_id,
          references(:vitoria_basque_handovers, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:vitoria_basque_receipts, [:receipt_code])
    create index(:vitoria_basque_receipts, [:vitoria_basque_handover_id])

    create table(:logrono_rioja_batches) do
      add :clerk, :string, null: false
      add :craft, :string, null: false
      add :batch_code, :string, null: false
      add :status, :string, null: false, default: "open"
      add :sealed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:logrono_rioja_batches, [:batch_code])

    create table(:logrono_rioja_notes) do
      add :body, :string, null: false

      add :logrono_rioja_batch_id, references(:logrono_rioja_batches, on_delete: :delete_all),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:logrono_rioja_notes, [:logrono_rioja_batch_id])
  end
end
