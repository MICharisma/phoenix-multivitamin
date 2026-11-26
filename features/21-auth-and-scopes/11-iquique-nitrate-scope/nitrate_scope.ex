# Auth and scopes · 11 · Iquique nitrate scope
#
# Teaches:
# - Scope for the hangar clerk and Iquique station id
# - station_id drives the scoped PubSub topic

defmodule PhoenixMultivitaminWeb.NitrateScope do
  @moduledoc false

  defstruct [:clerk, :station_id]

  @type t :: %__MODULE__{clerk: String.t(), station_id: String.t()}

  def for_clerk(clerk, station_id \\ "IQQ")

  def for_clerk("Valentina", station_id) when is_binary(station_id) do
    %__MODULE__{clerk: "Valentina", station_id: station_id}
  end

  def for_clerk(_, _), do: nil
end
