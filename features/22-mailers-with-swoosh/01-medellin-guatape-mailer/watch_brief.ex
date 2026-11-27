# Mailers with Swoosh · 01 · Medellín Guatapé mailer
#
# Teaches:
# - A domain brief as a defstruct with @enforce_keys

defmodule PhoenixMultivitaminWeb.MedellinGuatapeWatchBrief do
  @moduledoc false

  @enforce_keys [:controller, :craft, :runway, :qnh]
  defstruct [:controller, :craft, :runway, :qnh]
end
