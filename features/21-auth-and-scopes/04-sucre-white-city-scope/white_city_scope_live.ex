# Auth and scopes · 04 · Sucre white-city scope
#
# Teaches:
# - Context list_slips/1 takes %Scope{} first
# - Session badge chooses Mateo's SRE scope or a foreign station

defmodule PhoenixMultivitaminWeb.SucreWhiteCityScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.WhiteCityBoards
  alias PhoenixMultivitaminWeb.WhiteCityScope

  @impl true
  def mount(_params, session, socket) do
    scope = scope_from_session(session)
    slips = WhiteCityBoards.list_slips(scope)

    {:ok,
     socket
     |> assign_scenario("Sucre white-city scope", "Mateo", "ATR 42-500")
     |> assign(:current_scope, scope)
     |> assign(:slips, slips)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 04 · Sucre white-city scope
      </p>

      <h1>Sucre white-city scope</h1>
      <p class="lede" phx-no-curly-interpolation>
        Load clerk {@clerk} lists fuel slips only for Sucre (SRE). Context
        functions take <code>%WhiteCityScope{}</code> as the first argument.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl id="scope-meta" class="station-meta">
        <dt>Clerk</dt>
        <dd id="scope-clerk">{@current_scope.clerk}</dd>
        <dt>Station</dt>
        <dd id="scope-station">{@current_scope.station}</dd>
      </dl>

      <ul id="fuel-slips">
        <li :for={slip <- @slips} id={"slip-" <> slip.id}>
          {slip.craft} · {slip.litres} L
        </li>
      </ul>

      <p :if={@slips == []} id="empty-slips" class="muted">
        No slips for station {@current_scope.station}.
      </p>
    </Layouts.catalog>
    """
  end

  defp scope_from_session(%{"white_city_badge" => "mateo-sre"}), do: WhiteCityScope.for_mateo()

  defp scope_from_session(%{"white_city_badge" => station}),
    do: WhiteCityScope.for_station(station)

  defp scope_from_session(_), do: WhiteCityScope.for_mateo()
end
