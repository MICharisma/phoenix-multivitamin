# Auth and scopes · 11 · Iquique nitrate scope
#
# Teaches:
# - Scoped PubSub topic "iquique:#{station_id}:nitrate"
# - subscribe/1 and broadcast helpers for notes and logout

defmodule PhoenixMultivitaminWeb.NitrateBoards do
  @moduledoc false

  alias PhoenixMultivitaminWeb.NitrateScope

  @pubsub PhoenixMultivitamin.PubSub

  def topic(%NitrateScope{station_id: station_id}), do: topic(station_id)

  def topic(station_id) when is_binary(station_id) do
    "iquique:#{station_id}:nitrate"
  end

  def subscribe(%NitrateScope{} = scope) do
    Phoenix.PubSub.subscribe(@pubsub, topic(scope))
  end

  def subscribe(station_id) when is_binary(station_id) do
    Phoenix.PubSub.subscribe(@pubsub, topic(station_id))
  end

  def broadcast_note(%NitrateScope{} = scope, body) when is_binary(body) do
    Phoenix.PubSub.broadcast(@pubsub, topic(scope), {:nitrate_note, scope.station_id, body})
  end

  def broadcast_logout(%NitrateScope{} = scope) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      topic(scope),
      {:nitrate_logout, scope.station_id}
    )
  end
end
