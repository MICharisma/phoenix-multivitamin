# Testing · 10 · Wellington tag range
#
# Teaches:
# - The catalog page names the sectors; describe/setup/tags live in the test

defmodule PhoenixMultivitaminWeb.WellingtonTagRangeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Wellington tag range", "Moana", "Dash 8-300")
     |> assign(:sectors, [:cook, :harbour])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 10 · Wellington tag range
      </p>

      <h1>Wellington tag range</h1>
      <p class="lede">
        Clerk {@clerk} boards the {@craft} on Cook Strait or Harbour. The test
        file uses <code>describe</code>, <code>setup</code>, <code>setup_all</code>,
        and context tags — not this page.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <ul id="sector-list">
        <li :for={sector <- @sectors} id={"sector-#{sector}"}>{sector}</li>
      </ul>
    </Layouts.app>
    """
  end
end
