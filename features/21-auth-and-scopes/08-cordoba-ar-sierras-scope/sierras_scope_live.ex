# Auth and scopes · 08 · Córdoba Sierras scope
#
# Teaches:
# - Public versus authenticated access on one LiveView
# - on_mount {SierrasAuth, :mount_optional} always continues
# - Public winds-aloft board always; charter desk only with a scope
# - Event "open_charter_desk" rejected without scope (handle_event heads)

defmodule PhoenixMultivitaminWeb.CordobaSierrasScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.SierrasAuth
  alias PhoenixMultivitaminWeb.SierrasScope

  on_mount {SierrasAuth, :mount_optional}

  @impl true
  def mount(_params, _session, socket) do
    winds = [
      %{id: "fl090", band: "FL090", knots: "18 kt from 240°"},
      %{id: "fl150", band: "FL150", knots: "32 kt from 260°"}
    ]

    {:ok,
     socket
     |> assign_scenario("Córdoba Sierras scope", "Emilia", "Cessna 208B Caravan")
     |> assign(:winds, winds)
     |> assign(:charter_desk, :closed)
     |> assign(:desk_message, nil)}
  end

  @impl true
  def handle_event("open_charter_desk", _params, %{assigns: %{current_scope: %SierrasScope{}}} = socket) do
    {:noreply,
     socket
     |> assign(:charter_desk, :open)
     |> assign(:desk_message, "Charter desk open for Emilia at COR")}
  end

  def handle_event("open_charter_desk", _params, socket) do
    {:noreply,
     socket
     |> assign(:charter_desk, :closed)
     |> assign(:desk_message, "Sign in before the charter desk unlocks")
     |> put_flash(:error, "Authenticated scope required for the charter desk")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Auth and scopes · 08 · Córdoba Sierras scope
      </p>

      <h1>Córdoba Sierras scope</h1>
      <p class="lede">
        Clerk {@clerk} flies scenic circuits over the Sierras in a {@craft}.
        The winds-aloft board is public; the charter desk needs a scope.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section id="sierras-winds-board" class="scenario">
        <h2>Winds aloft (public)</h2>
        <ul id="winds-list">
          <li :for={wind <- @winds} id={"wind-#{wind.id}"}>
            {wind.band}: {wind.knots}
          </li>
        </ul>
      </section>

      <%= case @current_scope do %>
        <% %SierrasScope{} = scope -> %>
          <section id="sierras-charter-panel" class="scenario">
            <h2>Charter desk</h2>
            <p id="scope-clerk">{scope.clerk}</p>
            <p id="scope-station">{scope.station}</p>
            <button id="open-charter-desk" type="button" phx-click="open_charter_desk">
              Open charter desk
            </button>
            <p id="charter-desk-state">{charter_label(@charter_desk)}</p>
            <p :if={@desk_message} id="desk-message">{@desk_message}</p>
          </section>
        <% nil -> %>
          <section id="sierras-guest-panel" class="scenario">
            <h2>Guest view</h2>
            <p id="guest-hint" class="muted">
              Public winds only. Emilia's charter desk stays locked without a scope.
            </p>
            <button id="open-charter-desk" type="button" phx-click="open_charter_desk">
              Try opening the charter desk
            </button>
            <p :if={@desk_message} id="desk-message">{@desk_message}</p>
          </section>
      <% end %>
    </Layouts.app>
    """
  end

  defp charter_label(:open), do: "open"
  defp charter_label(:closed), do: "closed"
end
