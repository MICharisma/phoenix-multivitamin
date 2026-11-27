# Auth and scopes · 02 · Arequipa Misti scope
#
# Teaches:
# - Module plug that assigns :current_scope from the session
# - init/1 turns keyword opts into a map
# - call/2 reads "misti_token" and assigns scope or nil

defmodule PhoenixMultivitaminWeb.MistiAssignScope do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn

  alias PhoenixMultivitaminWeb.MistiScope

  @impl true
  def init(opts) do
    %{
      session_key: Keyword.get(opts, :session_key, "misti_token"),
      desk: Keyword.get(opts, :desk, "Misti ash desk")
    }
  end

  @impl true
  def call(conn, %{session_key: session_key, desk: desk}) do
    scope =
      conn
      |> get_session(session_key)
      |> MistiScope.from_token()

    conn
    |> assign(:current_scope, scope)
    |> assign(:desk, desk)
  end
end
