# Auth and scopes · 03 · La Paz altiplano scope
#
# Teaches:
# - on_mount require pattern for the LiveView side
# - with for session lookup before assigning :current_scope

defmodule PhoenixMultivitaminWeb.LaPazAltiplanoScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.AltiplanoScope

  on_mount {__MODULE__, :require_oxygen_clerk}

  def on_mount(:require_oxygen_clerk, _params, session, socket) do
    with token when is_binary(token) <- session["altiplano_token"],
         %AltiplanoScope{} = scope <- AltiplanoScope.from_token(token) do
      {:cont, assign(socket, :current_scope, scope)}
    else
      _ ->
        {:cont, assign(socket, :current_scope, nil)}
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("La Paz altiplano scope", "Camila", "Boeing 737-700")
     |> assign(:roster_path, "/features/21-auth-and-scopes/03-la-paz-altiplano-scope")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Auth and scopes · 03 · La Paz altiplano scope
      </p>

      <h1>La Paz altiplano scope</h1>
      <p class="lede">
        Oxygen clerk {@clerk} works El Alto (LPB). The require-auth plug
        redirects and halts when the altiplano token is missing.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= cond do %>
        <% match?(%AltiplanoScope{}, @current_scope) -> %>
          <dl id="oxygen-board" class="station-meta">
            <dt>Clerk</dt>
            <dd id="scope-clerk">{@current_scope.clerk}</dd>
            <dt>Station</dt>
            <dd id="scope-station">{@current_scope.station}</dd>
            <dt>Desk</dt>
            <dd id="scope-desk">{@current_scope.desk}</dd>
          </dl>
        <% true -> %>
          <p id="oxygen-roster" class="muted">
            Oxygen roster. Sign in with an altiplano token before bottles leave the crib.
          </p>
      <% end %>
    </Layouts.app>
    """
  end
end
