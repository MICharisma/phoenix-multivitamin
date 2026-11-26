# Auth and scopes · 07 · Montevideo Rambla scope
#
# Teaches:
# - Multi-clause on_mount/4 like mix phx.gen.auth
# - :mount_current_scope always assigns current_scope (possibly nil)
# - :require_authenticated halts and redirects when scope is nil

defmodule PhoenixMultivitaminWeb.RamblaAuth do
  @moduledoc false
  import Phoenix.LiveView
  import Phoenix.Component

  alias PhoenixMultivitaminWeb.RamblaScope

  def on_mount(:mount_current_scope, _params, session, socket) do
    scope = RamblaScope.from_token(session["rambla_token"])
    {:cont, assign(socket, :current_scope, scope)}
  end

  def on_mount(:require_authenticated, _params, session, socket) do
    socket = ensure_scope(socket, session)

    case socket.assigns.current_scope do
      %RamblaScope{} ->
        {:cont, socket}

      nil ->
        {:halt, redirect(socket, to: "/")}
    end
  end

  defp ensure_scope(%{assigns: %{current_scope: _}} = socket, _session), do: socket

  defp ensure_scope(socket, session) do
    assign(socket, :current_scope, RamblaScope.from_token(session["rambla_token"]))
  end
end
