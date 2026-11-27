# Ecto queries and contexts · 12 · Buenos Aires ledger stream
#
# Teaches:
# - Ledger line schema for Repo.stream

defmodule PhoenixMultivitamin.BuenosAiresLedgerLine do
  @moduledoc false
  use Ecto.Schema

  schema "buenos_aires_ledger_lines" do
    field :clerk, :string
    field :craft, :string
    field :entry, :string
    field :litres, :integer

    timestamps(type: :utc_datetime)
  end
end
