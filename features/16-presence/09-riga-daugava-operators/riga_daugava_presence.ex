defmodule PhoenixMultivitaminWeb.RigaDaugavaPresence do
  @moduledoc """
  Presence for the Riga operations room. Metas carry only the console; the
  operator profile is overlaid once per list or diff in `fetch/2`.
  """
  use Phoenix.Presence,
    otp_app: :phoenix_multivitamin,
    pubsub_server: PhoenixMultivitamin.PubSub

  alias PhoenixMultivitaminWeb.RigaOperatorRoster

  @impl true
  def fetch(_topic, presences) do
    profiles = presences |> Map.keys() |> RigaOperatorRoster.profiles()

    for {licence, presence} <- presences, into: %{} do
      {licence, Map.put(presence, :profile, profiles[licence])}
    end
  end
end
