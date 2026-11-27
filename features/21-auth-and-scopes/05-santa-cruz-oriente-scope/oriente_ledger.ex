# Auth and scopes · 05 · Santa Cruz oriente scope
#
# Teaches:
# - Never raw all/1 — filter by station_id in "queries"
# - for comprehension filters the private @shipments list
# - Enum.reduce totals only the scoped rows

defmodule PhoenixMultivitaminWeb.OrienteLedger do
  @moduledoc false

  alias PhoenixMultivitaminWeb.OrienteScope

  @shipments [
    %{id: "soya-41", station_id: "VVI", label: "Soya meal", kg: 12_400},
    %{id: "beef-09", station_id: "VVI", label: "Chilled beef", kg: 3_200},
    %{id: "gas-lpb", station_id: "LPB", label: "Bottled oxygen", kg: 890},
    %{id: "sugar-sre", station_id: "SRE", label: "Bagged sugar", kg: 5_100},
    %{id: "timber-vvi", station_id: "VVI", label: "Hardwood timber", kg: 7_750}
  ]

  def list_shipments(%OrienteScope{station_id: station_id}) do
    for shipment <- @shipments, shipment.station_id == station_id, do: shipment
  end

  def total_kg(%OrienteScope{} = scope) do
    scope
    |> list_shipments()
    |> Enum.reduce(0, fn shipment, acc -> acc + shipment.kg end)
  end

  def stations_present(%OrienteScope{} = scope) do
    for %{station_id: id} <- list_shipments(scope), uniq: true, do: id
  end
end
