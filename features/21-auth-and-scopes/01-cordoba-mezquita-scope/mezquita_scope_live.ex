# Auth and scopes · 01 · Córdoba Mezquita scope
#
# Teaches:
# - Scope defstruct with @enforce_keys [:controller, :station]
# - for_controller/2 turns a session badge into %MezquitaScope{}
# - Assign :current_scope on the socket, not a bare user

defmodule PhoenixMultivitaminWeb.CordobaMezquitaScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MezquitaScope

  @impl true
  def mount(_params, session, socket) do
    scope = MezquitaScope.for_controller(session["mezquita_badge"], "COR")

    socket =
      socket
      |> assign_scenario("Córdoba Mezquita scope", "Lucía", "ATR 72-600")
      |> assign(:current_scope, scope)
      |> assign_board(scope)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 01 · Córdoba Mezquita scope
      </p>

      <h1>Córdoba Mezquita scope</h1>
      <p class="lede">
        Controller {@clerk} works the Mezquita hangar desk at Córdoba. The
        session badge becomes a <code>:current_scope</code>, never a bare user.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= case @current_scope do %>
        <% %MezquitaScope{} = scope -> %>
          <dl id="mezquita-board" class="station-meta">
            <dt>Controller</dt>
            <dd id="scope-controller">{scope.controller}</dd>
            <dt>Station</dt>
            <dd id="scope-station">{scope.station}</dd>
            <dt>Desk</dt>
            <dd id="desk-state">Mezquita hangar open</dd>
          </dl>
        <% nil -> %>
          <p id="guest-board" class="muted">
            Guest board. Clip a Mezquita badge before the hangar desk opens.
          </p>
      <% end %>
    </Layouts.app>
    """
  end

  defp assign_board(socket, %MezquitaScope{}), do: assign(socket, :board, :open)
  defp assign_board(socket, nil), do: assign(socket, :board, :guest)
end
