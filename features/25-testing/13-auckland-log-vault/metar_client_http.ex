# Testing · 13 · Auckland METAR HTTP stub
#
# Teaches:
# - The default behaviour impl stays offline in this bottle

defmodule PhoenixMultivitamin.AucklandMetarClient.Http do
  @moduledoc false
  @behaviour PhoenixMultivitamin.AucklandMetarClient

  @impl true
  def fetch(station) do
    {:error, {:live_http_disabled, station}}
  end
end
