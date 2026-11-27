# Auth and scopes · 04 · Sucre white-city scope
#
# Teaches:
# - Context functions take %Scope{} as the first argument
# - Multiple function heads on scope station
# - Wrong station returns [] or raises on get_slip!

defmodule PhoenixMultivitaminWeb.WhiteCityBoards do
  @moduledoc false

  alias PhoenixMultivitaminWeb.WhiteCityScope

  @slips [
    %{id: "jet-a1", station: "SRE", craft: "ATR 42-500", litres: 2_400},
    %{id: "avgas-12", station: "SRE", craft: "Cessna 208B", litres: 380},
    %{id: "jet-vvi", station: "VVI", craft: "Boeing 737-800", litres: 8_100}
  ]

  def list_slips(%WhiteCityScope{station: "SRE"}) do
    Enum.filter(@slips, &(&1.station == "SRE"))
  end

  def list_slips(%WhiteCityScope{station: _other}), do: []

  def get_slip!(%WhiteCityScope{station: "SRE"}, id) do
    Enum.find(@slips, &(&1.id == id and &1.station == "SRE")) ||
      raise ArgumentError, "fuel slip #{id} is not on the Sucre board"
  end

  def get_slip!(%WhiteCityScope{station: station}, id) do
    raise ArgumentError, "station #{station} cannot open slip #{id}"
  end
end
