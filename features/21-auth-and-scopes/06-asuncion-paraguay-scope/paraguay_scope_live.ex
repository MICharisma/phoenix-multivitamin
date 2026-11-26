# Auth and scopes · 06 · Asunción Paraguay scope
#
# Teaches:
# - LiveView declares on_mount {ParaguayAuth, :require}
# - Missing scope halts with a redirect to /

defmodule PhoenixMultivitaminWeb.AsuncionParaguayScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  on_mount {PhoenixMultivitaminWeb.ParaguayAuth, :require}

  @impl true
  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope

    {:ok,
     socket
     |> assign_scenario("Asunción Paraguay scope", "Thiago", "Airbus A320")
     |> assign(:watch_label, scope.watch)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Auth and scopes · 06 · Asunción Paraguay scope
      </p>

      <h1>Asunción Paraguay scope</h1>
      <p class="lede">
        Controller {@clerk} runs the Silvio Pettirossi (ASU) night ops board.
        Without a Paraguay token the on_mount hook redirects to the catalog.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl id="night-ops-board" class="station-meta">
        <dt>Controller</dt>
        <dd id="scope-controller">{@current_scope.controller}</dd>
        <dt>Station</dt>
        <dd id="scope-station">{@current_scope.station}</dd>
        <dt>Watch</dt>
        <dd id="scope-watch">{@watch_label}</dd>
      </dl>
    </Layouts.catalog>
    """
  end
end
