# Testing · 06 · Hobart frost cell
#
# Teaches:
# - LiveViewTest clicks a LiveComponent through its own DOM id
# - send_update/3 refreshes the cell; the parent assign can stay put

defmodule PhoenixMultivitaminWeb.HobartFrostCellLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.HobartFrostCell

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Hobart frost cell", "Elspeth", "Dash 8-200")
     |> assign(:parent_taps, 0)}
  end

  @impl true
  def handle_info({:frost_tapped, taps}, socket) do
    {:noreply, assign(socket, :parent_taps, taps)}
  end

  @impl true
  def handle_event("post_note", _params, socket) do
    send_update(HobartFrostCell,
      id: "frost-cell",
      note: "Derwent frost noted on the Dash 8-200"
    )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 06 · Hobart frost cell
      </p>

      <h1>Hobart frost cell</h1>
      <p class="lede">
        Clerk {@clerk} taps frost on the {@craft} from a LiveComponent. Tests
        click <code>#tap-frost</code> and assert the cell id, not the parent.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="parent-taps">{@parent_taps}</p>

      <.live_component
        module={HobartFrostCell}
        id="frost-cell"
        clerk={@clerk}
        craft={@craft}
      />

      <button id="post-note" type="button" phx-click="post_note">Post Derwent note</button>
    </Layouts.app>
    """
  end
end
