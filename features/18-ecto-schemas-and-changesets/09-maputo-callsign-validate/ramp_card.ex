# Ecto schemas and changesets · 09 · Maputo ramp card
#
# Teaches:
# - validate_change/3 with a custom ICAO callsign function

defmodule PhoenixMultivitamin.MaputoRampCard do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :clerk, :string
    field :craft, :string
    field :callsign, :string
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:clerk, :craft, :callsign])
    |> validate_required([:clerk, :craft, :callsign])
    |> validate_change(:callsign, &icao_callsign/2)
  end

  defp icao_callsign(:callsign, callsign) do
    if Regex.match?(~r/\A[A-Z]{3}[0-9]{1,4}[A-Z]?\z/, callsign) do
      []
    else
      [callsign: "must look like an ICAO callsign (e.g. LAM312)"]
    end
  end
end
