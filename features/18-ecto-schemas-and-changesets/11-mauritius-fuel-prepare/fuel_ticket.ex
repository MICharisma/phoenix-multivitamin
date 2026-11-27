# Ecto schemas and changesets · 11 · Mauritius fuel ticket
#
# Teaches:
# - prepare_changes/2 normalizes litres only when the changeset is valid

defmodule PhoenixMultivitamin.MauritiusFuelTicket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "mauritius_fuel_tickets" do
    field :clerk, :string
    field :craft, :string
    field :litres, :integer
    field :unit_hint, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:clerk, :craft, :litres, :unit_hint])
    |> validate_required([:clerk, :craft, :litres])
    |> validate_number(:litres, greater_than: 0)
    |> prepare_changes(&normalize_unit/1)
  end

  defp normalize_unit(changeset) do
    case {get_field(changeset, :unit_hint), get_field(changeset, :litres)} do
      {"us_gallon", litres} when is_integer(litres) ->
        put_change(changeset, :litres, round(litres * 3.785))

      {_other, _litres} ->
        changeset
    end
  end
end
