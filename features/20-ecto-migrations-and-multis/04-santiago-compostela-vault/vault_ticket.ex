# Ecto migrations and multis · 04 · Santiago Compostela vault
#
# Teaches:
# - unique_constraint/3 mirrors the unique index
# - validate_number/3 stands in for the CHECK SQLite will not add via ALTER

defmodule PhoenixMultivitamin.SantiagoVaultTicket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "santiago_vault_tickets" do
    field :clerk, :string
    field :craft, :string
    field :vault_code, :string
    field :litres, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:clerk, :craft, :vault_code, :litres])
    |> validate_required([:clerk, :craft, :vault_code, :litres])
    |> validate_number(:litres, greater_than: 0)
    |> unique_constraint(:vault_code)
  end
end
