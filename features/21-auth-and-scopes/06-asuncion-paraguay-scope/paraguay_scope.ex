# Auth and scopes · 06 · Asunción Paraguay scope
#
# Teaches:
# - Scope for night ops controller Thiago at Silvio Pettirossi
# - from_token/1 used by the on_mount require hook

defmodule PhoenixMultivitaminWeb.ParaguayScope do
  @moduledoc false

  defstruct [:controller, :station, :watch]

  @type t :: %__MODULE__{
          controller: String.t(),
          station: String.t(),
          watch: String.t()
        }

  def from_token("thiago-asu") do
    %__MODULE__{controller: "Thiago", station: "ASU", watch: "night ops"}
  end

  def from_token(_), do: nil
end
