# Auth and scopes · 08 · Córdoba Sierras scope
#
# Teaches:
# - on_mount :mount_optional always continues
# - Assigns nil or a %SierrasScope{} from the session

defmodule PhoenixMultivitaminWeb.SierrasAuth do
  @moduledoc false

  import Phoenix.Component, only: [assign: 2]

  alias PhoenixMultivitaminWeb.SierrasScope

  def on_mount(:mount_optional, _params, session, socket) do
    scope =
      case session do
        %{"sierras_clerk" => clerk} -> SierrasScope.for_clerk(clerk)
        _ -> nil
      end

    {:cont, assign(socket, current_scope: scope)}
  end
end
