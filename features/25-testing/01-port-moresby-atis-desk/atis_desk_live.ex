# Testing · 01 · Port Moresby ATIS desk
#
# Teaches:
# - The catalog page is a LiveView; the working desk is a ConnCase controller
# - Tests assert html_response/2 and json_response/2 on named routes

defmodule PhoenixMultivitaminWeb.PortMoresbyAtisDeskLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Port Moresby ATIS desk", "Kila", "Dash 8-200")
     |> assign(:station, "Jacksons International")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 01 · Port Moresby ATIS desk
      </p>

      <h1>Port Moresby ATIS desk</h1>
      <p class="lede">
        Clerk {@clerk} posts the {@craft} ATIS as HTML and as JSON. ConnCase
        locks both shapes without opening a LiveView socket.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="station-name">{@station}</p>

      <div class="watch-switcher">
        <.link
          id="open-atis"
          href={~p"/features/25-testing/01-port-moresby-atis-desk/atis"}
        >
          Open the ATIS board
        </.link>
        <.link
          id="export-atis"
          href={~p"/features/25-testing/01-port-moresby-atis-desk/atis/export"}
        >
          Export JSON
        </.link>
      </div>
    </Layouts.app>
    """
  end
end
