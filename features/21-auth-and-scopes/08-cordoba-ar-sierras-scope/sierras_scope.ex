# Auth and scopes · 08 · Córdoba Sierras scope
#
# Teaches:
# - Scope struct for the scenic-flight clerk and Córdoba station
# - for_clerk/1 returns nil for guests, a scope for Emilia

defmodule PhoenixMultivitaminWeb.SierrasScope do
  @moduledoc false

  defstruct [:clerk, :station]

  @type t :: %__MODULE__{clerk: String.t(), station: String.t()}

  def for_clerk("Emilia") do
    %__MODULE__{clerk: "Emilia", station: "COR"}
  end

  def for_clerk(_), do: nil
end
