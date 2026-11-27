# Ecto schemas and changesets · 07 · Cape Town duty card
#
# Teaches:
# - Ecto.Enum maps atoms in Elixir to string values in the form

defmodule PhoenixMultivitamin.CapeTownDutyCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :clerk, :string
    field :craft, :string

    field :status, Ecto.Enum,
      values: [briefing: "briefing", airborne: "airborne", released: "released"]
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :status])
    |> validate_required([:clerk, :craft, :status])
    |> validate_release()
  end

  defp validate_release(changeset) do
    case get_field(changeset, :status) do
      :released ->
        validate_length(changeset, :clerk, min: 2)

      _other ->
        changeset
    end
  end
end
