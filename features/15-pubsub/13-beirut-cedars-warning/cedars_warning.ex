defmodule PhoenixMultivitaminWeb.CedarsWarning do
  @moduledoc false
  @enforce_keys [:id, :hazard, :runway, :issued_by, :origin]
  defstruct [:id, :hazard, :runway, :issued_by, :origin, acks: []]

  @hazards %{"wind_shear" => "Wind shear", "bird_strike" => "Bird activity", "fod" => "Debris"}
  @runways ~w(03 21 16 34 17 35)

  def hazards, do: @hazards
  def runways, do: @runways

  def issue(%{"hazard" => hazard, "runway" => runway}, desk)
      when is_map_key(@hazards, hazard) and runway in @runways do
    {:ok,
     %__MODULE__{
       id: System.unique_integer([:positive, :monotonic]),
       hazard: Map.fetch!(@hazards, hazard),
       runway: runway,
       issued_by: desk,
       origin: self()
     }}
  end

  def issue(_params, _desk), do: {:error, :unknown_hazard_or_runway}

  def acknowledge(%__MODULE__{acks: acks} = warning, desk) do
    if desk in acks, do: warning, else: %{warning | acks: Enum.sort([desk | acks])}
  end
end
