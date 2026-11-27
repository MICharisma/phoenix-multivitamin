# Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi
#
# Teaches:
# - Line schema whose validation failure short-circuits the Multi

defmodule PhoenixMultivitamin.SalamancaPlazaLine do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "salamanca_plaza_lines" do
    field :part, :string
    field :qty, :integer

    belongs_to :order, PhoenixMultivitamin.SalamancaPlazaOrder,
      foreign_key: :salamanca_plaza_order_id

    timestamps(type: :utc_datetime)
  end

  def changeset(line, attrs) do
    line
    |> cast(attrs, [:part, :qty, :salamanca_plaza_order_id])
    |> validate_required([:part, :qty, :salamanca_plaza_order_id])
    |> validate_number(:qty, greater_than: 0)
  end
end
