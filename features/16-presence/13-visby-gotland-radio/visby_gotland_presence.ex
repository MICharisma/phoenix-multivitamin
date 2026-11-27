defmodule PhoenixMultivitaminWeb.VisbyGotlandPresence do
  @moduledoc """
  Presence for the Gotland radio net. Metas carry the tuned frequency; the
  station's site and operator are overlaid in `fetch/2`.
  """
  use Phoenix.Presence,
    otp_app: :phoenix_multivitamin,
    pubsub_server: PhoenixMultivitamin.PubSub

  @stations %{
    "Visby Radio" => %{site: "Visby airport tower", operator: "Ebba"},
    "Fårö Relay" => %{site: "Fårö lighthouse mast", operator: "Linnea"},
    "Slite Base" => %{site: "Slite harbour hangar", operator: "Oskar"},
    "Hoburgen Relay" => %{site: "Hoburgen cliff mast", operator: "Sigrid"}
  }
  @unlisted %{site: "unlisted site", operator: "unlisted operator"}

  @impl true
  def fetch(_topic, presences) do
    Map.new(presences, fn {call_sign, presence} ->
      {call_sign, Map.merge(presence, Map.get(@stations, call_sign, @unlisted))}
    end)
  end
end
