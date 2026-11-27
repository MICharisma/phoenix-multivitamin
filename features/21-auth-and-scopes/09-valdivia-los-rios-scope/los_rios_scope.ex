# Auth and scopes · 09 · Valdivia Los Ríos scope
#
# Teaches:
# - Scope built from a redeemed magic-link token
# - Never assign :current_user — the token becomes a Scope

defmodule PhoenixMultivitaminWeb.LosRiosScope do
  @moduledoc false

  defstruct [:clerk, :station, :token]

  @type t :: %__MODULE__{clerk: String.t(), station: String.t(), token: String.t()}

  def for_clerk(clerk, token) when is_binary(clerk) and is_binary(token) do
    %__MODULE__{clerk: clerk, station: "ZAL", token: token}
  end
end
