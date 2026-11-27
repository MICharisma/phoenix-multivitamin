# Testing · 13 · Auckland METAR client behaviour
#
# Teaches:
# - A behaviour swaps the Waitematā METAR source via Application config
# - No Mox — the fake module is a real implementation

defmodule PhoenixMultivitamin.AucklandMetarClient do
  @moduledoc false

  @callback fetch(station :: String.t()) :: {:ok, map()} | {:error, term()}

  def fetch(station) when is_binary(station) do
    impl().fetch(station)
  end

  defp impl do
    Application.get_env(
      :phoenix_multivitamin,
      :auckland_metar_client,
      PhoenixMultivitamin.AucklandMetarClient.Http
    )
  end
end
