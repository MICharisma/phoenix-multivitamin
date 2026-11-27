# Auth and scopes · 07 · Montevideo Rambla scope
#
# Teaches:
# - Scope for METAR clerk Sofía at Carrasco
# - from_token/1 used by multi-clause on_mount hooks

defmodule PhoenixMultivitaminWeb.RamblaScope do
  @moduledoc false

  defstruct [:clerk, :station, :desk]

  @type t :: %__MODULE__{clerk: String.t(), station: String.t(), desk: String.t()}

  def from_token("sofia-mvd") do
    %__MODULE__{clerk: "Sofía", station: "MVD", desk: "Rambla METAR"}
  end

  def from_token(_), do: nil
end
