# Auth and scopes · 07 · Montevideo Rambla scope
#
# Teaches:
# - LiveView uses on_mount {RamblaAuth, :require_authenticated}
# - Multi-clause auth mirrors mix phx.gen.auth style hooks

defmodule PhoenixMultivitaminWeb.MontevideoRamblaScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  on_mount {PhoenixMultivitaminWeb.RamblaAuth, :require_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Montevideo Rambla scope", "Sofía", "Embraer E190")
     |> assign(:metar, "MVD 261800Z 18012KT 9999 FEW025 22/14 Q1016")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 07 · Montevideo Rambla scope
      </p>

      <h1>Montevideo Rambla scope</h1>
      <p class="lede">
        Clerk {@clerk} keeps the Carrasco (MVD) Rambla coastal METAR desk.
        <code>require_authenticated</code>
        builds on <code>mount_current_scope</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl id="rambla-board" class="station-meta">
        <dt>Clerk</dt>
        <dd id="scope-clerk">{@current_scope.clerk}</dd>
        <dt>Station</dt>
        <dd id="scope-station">{@current_scope.station}</dd>
        <dt>Desk</dt>
        <dd id="scope-desk">{@current_scope.desk}</dd>
        <dt>METAR</dt>
        <dd id="metar-line">{@metar}</dd>
      </dl>
    </Layouts.app>
    """
  end
end
