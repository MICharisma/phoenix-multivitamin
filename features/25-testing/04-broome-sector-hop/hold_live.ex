# Testing · 04 · Broome hold board
#
# Teaches:
# - A separate LiveView is the follow_redirect landing pad

defmodule PhoenixMultivitaminWeb.BroomeHoldLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Broome hold board", "Jarrah", "Dash 8-300")
     |> assign(:surface, "hold")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 04 · Broome hold board
      </p>

      <h1>Broome hold board</h1>
      <p class="lede">
        Clerk {@clerk} parks the {@craft} on the hold after a navigate.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="surface-name">{@surface}</p>
    </Layouts.app>
    """
  end
end
