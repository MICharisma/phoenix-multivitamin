# Auth and scopes · 01 · Córdoba Mezquita scope
#
# Teaches:
# - Scope defstruct with @enforce_keys [:controller, :station]
# - for_controller/2 builds a scope from a badge, never a bare user assign
# - Pattern match on %Scope{} keeps the hangar desk typed

defmodule PhoenixMultivitaminWeb.MezquitaScope do
  @moduledoc false

  @enforce_keys [:controller, :station]
  defstruct [:controller, :station]

  @type t :: %__MODULE__{controller: String.t(), station: String.t()}

  def for_controller(nil, _station), do: nil

  def for_controller(badge, station) when is_binary(badge) and is_binary(station) do
    case badge do
      "lucia-cor" -> %__MODULE__{controller: "Lucía", station: station}
      _ -> nil
    end
  end
end
