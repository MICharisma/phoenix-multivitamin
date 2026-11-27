defmodule PhoenixMultivitamin.SharjahCreekHail do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @reporting_points ["Al Khan", "Khalid Lagoon", "Mamzar", "Creek Mouth"]

  schema "sharjah_creek_hails" do
    field :callsign, :string
    field :reporting_point, :string
    field :altitude_ft, :integer
    timestamps(type: :utc_datetime)
  end

  def reporting_points, do: @reporting_points

  def changeset(hail, attrs) do
    hail
    |> cast(attrs, [:callsign, :reporting_point, :altitude_ft])
    |> validate_required([:callsign, :reporting_point, :altitude_ft])
    |> update_change(:callsign, &String.upcase/1)
    |> validate_format(:callsign, ~r/^A6-[A-Z]{3}$/,
      message: "must be a UAE registration like A6-SHJ"
    )
    |> validate_inclusion(:reporting_point, @reporting_points)
    |> validate_number(:altitude_ft, greater_than_or_equal_to: 500, less_than_or_equal_to: 1500)
  end
end
