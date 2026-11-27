# Auth and scopes · 13 · Cartagena walled scope
#
# Teaches:
# - fetch_current_scope plug (tested via Plug.call)
# - on_mount :require that redirects when the scope is missing or wrong station
# - Session renewal helper and scoped logout broadcast

defmodule PhoenixMultivitaminWeb.WalledAuth do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Component, only: [assign: 2]

  alias PhoenixMultivitaminWeb.WalledScope

  @pubsub PhoenixMultivitamin.PubSub
  @session_clerk "walled_clerk"
  @session_station "walled_station"
  @session_at "walled_authenticated_at"

  @impl true
  def init(opts), do: Map.new(opts)

  @impl true
  def call(conn, _opts) do
    assign(conn, :current_scope, scope_from_session(conn))
  end

  def on_mount(:require, _params, session, socket) do
    case scope_from_map(session) do
      %WalledScope{station: "CTG"} = scope ->
        {:cont, assign(socket, current_scope: scope)}

      %WalledScope{} = scope ->
        socket =
          socket
          |> assign(current_scope: scope)
          |> Phoenix.LiveView.put_flash(:error, "Barranquilla scope cannot open the CTG harbour")

        {:cont, socket}

      nil ->
        {:cont, assign(socket, current_scope: nil)}
    end
  end

  def topic(%WalledScope{station: station}), do: "cartagena:#{station}:harbour"

  def broadcast_logout(%WalledScope{} = scope) do
    Phoenix.PubSub.broadcast(
      @pubsub,
      topic(scope),
      {:walled_logout, scope.station}
    )
  end

  def subscribe(%WalledScope{} = scope) do
    Phoenix.PubSub.subscribe(@pubsub, topic(scope))
  end

  def renew_scope(%WalledScope{} = scope) do
    WalledScope.put_authenticated_at(scope, DateTime.utc_now())
  end

  def session_keys, do: {@session_clerk, @session_station, @session_at}

  defp scope_from_session(conn) do
    scope_from_map(%{
      @session_clerk => get_session(conn, @session_clerk),
      @session_station => get_session(conn, @session_station),
      @session_at => get_session(conn, @session_at)
    })
  end

  defp scope_from_map(session) when is_map(session) do
    with clerk when is_binary(clerk) <- session[@session_clerk] || session[:walled_clerk],
         station when is_binary(station) <- session[@session_station] || session[:walled_station],
         iso when is_binary(iso) <-
           session[@session_at] || session[:walled_authenticated_at],
         {:ok, at, _} <- DateTime.from_iso8601(iso) do
      WalledScope.for_clerk(clerk, station, at)
    else
      _ -> nil
    end
  end
end
