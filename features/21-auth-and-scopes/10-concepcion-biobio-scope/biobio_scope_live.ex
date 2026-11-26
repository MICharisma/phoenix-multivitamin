# Auth and scopes · 10 · Concepción Biobío scope
#
# Teaches:
# - Sudo mode — recent authenticated_at on the scope
# - require_sudo within the window for unlock_master_plates
# - renew_session refreshes authenticated_at (cond + DateTime.utc_now)

defmodule PhoenixMultivitaminWeb.ConcepcionBiobioScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.BiobioScope
  alias PhoenixMultivitaminWeb.BiobioSudo

  @impl true
  def mount(_params, session, socket) do
    scope = scope_from_session(session)

    {:ok,
     socket
     |> assign_scenario("Concepción Biobío scope", "Ignacio", "Airbus A320")
     |> assign(:current_scope, scope)
     |> assign(:drawer, :locked)
     |> assign(:drawer_message, nil)}
  end

  @impl true
  def handle_event("unlock_master_plates", _params, socket) do
    scope = socket.assigns.current_scope

    socket =
      cond do
        is_nil(scope) ->
          socket
          |> assign(:drawer, :locked)
          |> assign(:drawer_message, "Sign in before the master plate drawer opens")
          |> put_flash(:error, "Scope required")

        BiobioSudo.sudo_valid?(scope) ->
          socket
          |> assign(:drawer, :open)
          |> assign(:drawer_message, "Master plates unlocked for Ignacio")

        true ->
          socket
          |> assign(:drawer, :locked)
          |> assign(:drawer_message, "Sudo window expired — renew the session")
          |> put_flash(:error, "Sudo required")
      end

    {:noreply, socket}
  end

  def handle_event("renew_session", _params, socket) do
    socket =
      case socket.assigns.current_scope do
        %BiobioScope{} = scope ->
          refreshed =
            scope
            |> BiobioScope.put_authenticated_at(DateTime.utc_now())

          socket
          |> assign(:current_scope, refreshed)
          |> assign(:drawer_message, "Session renewed — sudo window reset")

        nil ->
          put_flash(socket, :error, "No Biobío scope to renew")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 10 · Concepción Biobío scope
      </p>

      <h1>Concepción Biobío scope</h1>
      <p class="lede">
        Clerk {@clerk} unlocks the Carriel Sur (CCP) master plate drawer for {@craft} approaches. Sudo needs a fresh <code>authenticated_at</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= if @current_scope do %>
        <dl id="biobio-board" class="station-meta">
          <dt>Clerk</dt>
          <dd id="scope-clerk">{@current_scope.clerk}</dd>
          <dt>Station</dt>
          <dd id="scope-station">{@current_scope.station}</dd>
          <dt>Authenticated at</dt>
          <dd id="authenticated-at">{DateTime.to_iso8601(@current_scope.authenticated_at)}</dd>
          <dt>Sudo</dt>
          <dd id="sudo-state">
            {if BiobioSudo.sudo_valid?(@current_scope), do: "valid", else: "stale"}
          </dd>
        </dl>

        <div id="plate-actions">
          <button id="unlock-master-plates" type="button" phx-click="unlock_master_plates">
            Unlock master plates
          </button>
          <button id="renew-session" type="button" phx-click="renew_session">
            Renew session
          </button>
        </div>
      <% else %>
        <p id="plates-locked-guest" class="muted">
          Approach plates stay in the drawer. Present a Biobío session.
        </p>
      <% end %>

      <p id="drawer-state">{drawer_label(@drawer)}</p>
      <p :if={@drawer_message} id="drawer-message">{@drawer_message}</p>
    </Layouts.app>
    """
  end

  defp scope_from_session(session) do
    with clerk when is_binary(clerk) <- session["biobio_clerk"],
         iso when is_binary(iso) <- session["biobio_authenticated_at"],
         {:ok, at} <- BiobioSudo.parse_authenticated_at(iso) do
      BiobioScope.for_clerk(clerk, at)
    else
      _ -> nil
    end
  end

  defp drawer_label(:open), do: "open"
  defp drawer_label(:locked), do: "locked"
end
