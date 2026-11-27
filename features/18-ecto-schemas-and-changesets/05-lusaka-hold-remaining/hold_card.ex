# Ecto schemas and changesets · 05 · Lusaka hold card
#
# Teaches:
# - Virtual fields cast and validate but never hit the table

defmodule PhoenixMultivitamin.LusakaHoldCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "lusaka_hold_cards" do
    field :clerk, :string
    field :craft, :string
    field :hold_min, :integer
    field :burned_min, :integer
    field :remaining_min, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :hold_min, :burned_min, :remaining_min])
    |> validate_required([:clerk, :craft, :hold_min, :burned_min])
    |> validate_number(:hold_min, greater_than: 0)
    |> validate_number(:burned_min, greater_than_or_equal_to: 0)
    |> put_remaining()
  end

  defp put_remaining(changeset) do
    hold = get_field(changeset, :hold_min)
    burned = get_field(changeset, :burned_min)

    cond do
      is_integer(hold) and is_integer(burned) and burned > hold ->
        add_error(changeset, :burned_min, "cannot exceed the hold")

      is_integer(hold) and is_integer(burned) ->
        put_change(changeset, :remaining_min, hold - burned)

      true ->
        changeset
    end
  end
end
