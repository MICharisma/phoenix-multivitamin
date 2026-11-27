# Ecto schemas and changesets · 03 · Dar es Salaam cargo bay
#
# Teaches:
# - A single nested embed for the bay layout

defmodule PhoenixMultivitamin.DarCargoBay do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :forward_kg, :integer
    field :aft_kg, :integer
  end

  def changeset(bay, attrs) do
    bay
    |> cast(attrs, [:forward_kg, :aft_kg])
    |> validate_required([:forward_kg, :aft_kg])
    |> validate_number(:forward_kg, greater_than_or_equal_to: 0)
    |> validate_number(:aft_kg, greater_than_or_equal_to: 0)
    |> validate_balance()
  end

  defp validate_balance(changeset) do
    forward = get_field(changeset, :forward_kg)
    aft = get_field(changeset, :aft_kg)

    cond do
      is_nil(forward) or is_nil(aft) ->
        changeset

      abs(forward - aft) > 400 ->
        add_error(changeset, :aft_kg, "must stay within 400 kg of the forward bay")

      true ->
        changeset
    end
  end
end
