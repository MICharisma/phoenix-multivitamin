# Auth and scopes · 05 · Santa Cruz oriente scope
#
# Teaches:
# - LiveView paints only Viru Viru rows from the scoped ledger
# - Totals come from Enum.reduce over the filtered list

defmodule PhoenixMultivitaminWeb.SantaCruzOrienteScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.OrienteLedger
  alias PhoenixMultivitaminWeb.OrienteScope

  @impl true
  def mount(_params, session, socket) do
    scope = scope_from_session(session)
    shipments = OrienteLedger.list_shipments(scope)

    {:ok,
     socket
     |> assign_scenario("Santa Cruz oriente scope", "Renata", "Boeing 767-300F")
     |> assign(:current_scope, scope)
     |> assign(:shipments, shipments)
     |> assign(:total_kg, OrienteLedger.total_kg(scope))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 05 · Santa Cruz oriente scope
      </p>

      <h1>Santa Cruz oriente scope</h1>
      <p class="lede">
        Cargo clerk {@clerk} keeps the Viru Viru (VVI) ledger. Queries filter
        by <code>station_id</code> — never a raw all/1 across the oriente.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl id="ledger-meta" class="station-meta">
        <dt>Clerk</dt>
        <dd id="scope-clerk">{@current_scope.clerk}</dd>
        <dt>Station</dt>
        <dd id="scope-station">{@current_scope.station_id}</dd>
        <dt>Total kg</dt>
        <dd id="ledger-total">{@total_kg}</dd>
      </dl>

      <ul id="cargo-ledger">
        <li :for={row <- @shipments} id={"shipment-" <> row.id}>
          <span id={"label-" <> row.id}>{row.label}</span>
          <span id={"kg-" <> row.id}>{row.kg}</span>
          <span id={"station-" <> row.id}>{row.station_id}</span>
        </li>
      </ul>
    </Layouts.app>
    """
  end

  defp scope_from_session(%{"oriente_badge" => "renata-vvi"}), do: OrienteScope.for_renata()
  defp scope_from_session(%{"oriente_badge" => station}), do: OrienteScope.for_station(station)
  defp scope_from_session(_), do: OrienteScope.for_renata()
end
