defmodule PhoenixMultivitaminWeb.SantoriniCalderaPresence do
  @moduledoc """
  Presence client for the Santorini caldera desk. `handle_metas/4` turns raw
  diffs into desk events and publishes them on `"<topic>:log"`.
  """
  use Phoenix.Presence,
    otp_app: :phoenix_multivitamin,
    pubsub_server: PhoenixMultivitamin.PubSub

  @impl true
  def init(_opts), do: {:ok, %{handovers: %{}}}

  @impl true
  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    {joined, handovers} =
      Enum.map_reduce(joins, Map.get(state.handovers, topic, 0), fn {agent, %{metas: metas}},
                                                                    count ->
        open_consoles = presences |> Map.get(agent, []) |> length()

        cond do
          open_consoles > length(metas) -> {{:second_console, agent, open_consoles}, count}
          true -> {{:took_desk, agent, hd(metas).counter, count + 1}, count + 1}
        end
      end)

    left =
      for {agent, _presence} <- leaves, not Map.has_key?(joins, agent) do
        case Map.fetch(presences, agent) do
          {:ok, remaining} -> {:closed_console, agent, length(remaining)}
          :error -> {:left_desk, agent}
        end
      end

    for event <- joined ++ left do
      Phoenix.PubSub.local_broadcast(
        PhoenixMultivitamin.PubSub,
        topic <> ":log",
        {:caldera_desk, event}
      )
    end

    {:ok, put_in(state, [:handovers, topic], handovers)}
  end
end
