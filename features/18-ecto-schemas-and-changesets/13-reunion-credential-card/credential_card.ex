# Ecto schemas and changesets · 13 · Réunion credential card
#
# Teaches:
# - redact: true hides the access token from inspect/1
# - change/2 for trusted hangar codes versus cast/3 for form params

defmodule PhoenixMultivitamin.ReunionCredentialCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "reunion_credential_cards" do
    field :clerk, :string
    field :craft, :string
    field :hangar_code, :string
    field :access_token, :string, redact: true

    timestamps(type: :utc_datetime)
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :access_token])
    |> validate_required([:clerk, :craft, :access_token])
    |> validate_length(:access_token, min: 8, max: 64)
    |> validate_format(:access_token, ~r/\A[A-Za-z0-9\-]+\z/)
  end

  def stamp_hangar(card_or_changeset, hangar_code) when is_binary(hangar_code) do
    card_or_changeset
    |> change(%{hangar_code: hangar_code})
    |> validate_required([:hangar_code])
    |> validate_length(:hangar_code, is: 4)
  end
end
