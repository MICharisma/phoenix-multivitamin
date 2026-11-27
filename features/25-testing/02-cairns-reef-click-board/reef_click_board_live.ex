# Testing · 02 · Cairns reef click board
#
# Teaches:
# - live/2 connects a LiveView under test
# - element/3 and has_element?/3 lock named DOM ids
# - render_click/1 posts a reef hazard without a browser

defmodule PhoenixMultivitaminWeb.CairnsReefClickBoardLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Cairns reef click board", "Marlee", "Twin Otter")
     |> assign(:hazards, [])
     |> assign(:reef_state, :clear)}
  end

  @impl true
  def handle_event("log_bommie", _params, socket) do
    {:noreply,
     socket
     |> update(:hazards, &["Bommie marked east of Green Island" | &1])
     |> assign(:reef_state, :caution)}
  end

  def handle_event("log_turtle", _params, socket) do
    {:noreply,
     socket
     |> update(:hazards, &["Green turtle raft on the reef flat" | &1])
     |> assign(:reef_state, :hold)}
  end

  def handle_event("clear_reef", _params, %{assigns: %{hazards: []}} = socket) do
    {:noreply, put_flash(socket, :info, "Reef already clear for Marlee.")}
  end

  def handle_event("clear_reef", _params, socket) do
    {:noreply, assign(socket, hazards: [], reef_state: :clear)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 02 · Cairns reef click board
      </p>

      <h1>Cairns reef click board</h1>
      <p class="lede">
        Clerk {@clerk} taps reef hazards for the {@craft}. LiveViewTest
        clicks the same buttons through <code>element/3</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="reef-state">{@reef_state}</p>

      <div class="watch-switcher">
        <button id="log-bommie" type="button" phx-click="log_bommie">Log bommie</button>
        <button id="log-turtle" type="button" phx-click="log_turtle">Log turtle raft</button>
        <button id="clear-reef" type="button" phx-click="clear_reef">Clear reef</button>
      </div>

      <ul id="reef-hazards">
        <li :for={{hazard, index} <- Enum.with_index(@hazards)} id={"hazard-#{index}"}>
          {hazard}
        </li>
      </ul>
      <p :if={@hazards == []} id="empty-reef">No hazards posted this watch.</p>
    </Layouts.app>
    """
  end
end
