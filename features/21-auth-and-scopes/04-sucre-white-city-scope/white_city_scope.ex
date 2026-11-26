# Auth and scopes · 04 · Sucre white-city scope
#
# Teaches:
# - Scope carries the load clerk and Sucre station
# - Context functions take %Scope{} as the first argument

defmodule PhoenixMultivitaminWeb.WhiteCityScope do
  @moduledoc false

  @enforce_keys [:clerk, :station]
  defstruct [:clerk, :station]

  @type t :: %__MODULE__{clerk: String.t(), station: String.t()}

  def for_mateo do
    %__MODULE__{clerk: "Mateo", station: "SRE"}
  end

  def for_station(station) when is_binary(station) do
    %__MODULE__{clerk: "relief", station: station}
  end
end
