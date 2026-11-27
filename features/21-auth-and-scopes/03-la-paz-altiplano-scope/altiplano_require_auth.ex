# Auth and scopes · 03 · La Paz altiplano scope
#
# Teaches:
# - require-authenticated plug: redirect + halt when scope is missing
# - call_without_halt/2 shows why halt matters after redirect
# - with for session token lookup

defmodule PhoenixMultivitaminWeb.AltiplanoRequireAuth do
  @moduledoc false
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  alias PhoenixMultivitaminWeb.AltiplanoScope

  @roster "/features/21-auth-and-scopes/03-la-paz-altiplano-scope"

  @impl true
  def init(opts), do: Map.new(opts)

  @impl true
  def call(conn, opts) do
    conn
    |> assign_or_redirect(opts)
    |> maybe_halt()
  end

  def call_without_halt(conn, opts) do
    assign_or_redirect(conn, opts)
  end

  defp assign_or_redirect(conn, _opts) do
    with token when is_binary(token) <- get_session(conn, "altiplano_token"),
         %AltiplanoScope{} = scope <- AltiplanoScope.from_token(token) do
      assign(conn, :current_scope, scope)
    else
      _ ->
        conn
        |> redirect(to: @roster)
    end
  end

  defp maybe_halt(%{assigns: %{current_scope: %AltiplanoScope{}}} = conn), do: conn
  defp maybe_halt(conn), do: halt(conn)
end
