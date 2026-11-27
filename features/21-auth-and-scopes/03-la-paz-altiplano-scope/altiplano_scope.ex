# Auth and scopes · 03 · La Paz altiplano scope
#
# Teaches:
# - Scope for the oxygen clerk and El Alto station
# - from_token/1 used inside with for session lookup

defmodule PhoenixMultivitaminWeb.AltiplanoScope do
  @moduledoc false

  defstruct [:clerk, :station, :desk]

  @type t :: %__MODULE__{clerk: String.t(), station: String.t(), desk: String.t()}

  def from_token("camila-lpb") do
    %__MODULE__{clerk: "Camila", station: "LPB", desk: "El Alto oxygen"}
  end

  def from_token(_), do: nil
end
