# Auth and scopes · 06 · Asunción Paraguay scope
#
# Teaches:
# - on_mount hook redirects with {:halt, redirect(...)} when scope is missing
# - {:cont, socket} continues with the scope assigned
# - Multi-shape return from on_mount/4

defmodule PhoenixMultivitaminWeb.ParaguayAuth do
  @moduledoc false
  import Phoenix.LiveView
  import Phoenix.Component

  alias PhoenixMultivitaminWeb.ParaguayScope

  def on_mount(:require, _params, session, socket) do
    case ParaguayScope.from_token(session["paraguay_token"]) do
      %ParaguayScope{} = scope ->
        {:cont, assign(socket, :current_scope, scope)}

      nil ->
        {:halt, redirect(socket, to: "/")}
    end
  end
end
