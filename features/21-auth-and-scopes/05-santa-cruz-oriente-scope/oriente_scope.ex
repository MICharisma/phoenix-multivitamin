# Auth and scopes · 05 · Santa Cruz oriente scope
#
# Teaches:
# - Scope carries clerk Renata and Viru Viru station id
# - Ledger queries filter by station_id from the scope

defmodule PhoenixMultivitaminWeb.OrienteScope do
  @moduledoc false

  @enforce_keys [:clerk, :station_id]
  defstruct [:clerk, :station_id]

  @type t :: %__MODULE__{clerk: String.t(), station_id: String.t()}

  def for_renata, do: %__MODULE__{clerk: "Renata", station_id: "VVI"}

  def for_station(station_id) when is_binary(station_id) do
    %__MODULE__{clerk: "relief", station_id: station_id}
  end
end
