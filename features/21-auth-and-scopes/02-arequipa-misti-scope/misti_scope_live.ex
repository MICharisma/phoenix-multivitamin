# Auth and scopes · 02 · Arequipa Misti scope
#
# Teaches:
# - LiveView mounts the same way the assign_scope plug does
# - Session "misti_token" becomes :current_scope on the socket

defmodule PhoenixMultivitaminWeb.ArequipaMistiScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MistiScope

  @impl true
  def mount(_params, session, socket) do
    scope = MistiScope.from_token(session["misti_token"])

    {:ok,
     socket
     |> assign_scenario("Arequipa Misti scope", "Inés", "DHC-6 Twin Otter")
     |> assign(:current_scope, scope)
     |> assign(:desk, "Misti ash desk")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 02 · Arequipa Misti scope
      </p>

      <h1>Arequipa Misti scope</h1>
      <p class="lede">
        Dispatcher {@clerk} watches volcanic ash at Rodríguez Ballón. The
        assign_scope plug and this LiveView both read <code>misti_token</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="desk-name">{@desk}</p>

      <%= if @current_scope do %>
        <dl id="misti-board" class="station-meta">
          <dt>Dispatcher</dt>
          <dd id="scope-dispatcher">{@current_scope.dispatcher}</dd>
          <dt>Station</dt>
          <dd id="scope-station">{@current_scope.station}</dd>
        </dl>
      <% else %>
        <p id="ash-locked" class="muted">
          Ash desk locked. Present a Misti token to open the board.
        </p>
      <% end %>
    </Layouts.catalog>
    """
  end
end
