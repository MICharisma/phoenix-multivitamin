# Testing · 04 · Broome sector hop
#
# Teaches:
# - push_patch updates the URL; assert_patch/2 locks it
# - push_navigate leaves the LiveView; follow_redirect/3 lands on the hold

defmodule PhoenixMultivitaminWeb.BroomeSectorHopLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Broome sector hop", "Jarrah", "Dash 8-300")
     |> assign(:sector, "cable")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    sector =
      case Map.get(params, "sector") do
        "pearl" -> "pearl"
        _ -> "cable"
      end

    {:noreply, assign(socket, :sector, sector)}
  end

  @impl true
  def handle_event("open_pearl", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/features/25-testing/04-broome-sector-hop?sector=pearl")}
  end

  def handle_event("open_hold", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/features/25-testing/04-broome-sector-hop/hold")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 04 · Broome sector hop
      </p>

      <h1>Broome sector hop</h1>
      <p class="lede">
        Clerk {@clerk} patches the {@craft} between Cable Beach and Pearl, then
        navigates to the hold. Tests use <code>assert_patch/2</code>
        and <code>follow_redirect/3</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="sector-name">{@sector}</p>

      <button id="open-pearl" type="button" phx-click="open_pearl">Open Pearl sector</button>
      <button id="open-hold" type="button" phx-click="open_hold">Open hold</button>
    </Layouts.app>
    """
  end
end
