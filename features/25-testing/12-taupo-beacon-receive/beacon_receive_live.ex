# Testing · 12 · Taupō beacon receive
#
# Teaches:
# - The LiveView subscribes to a volcanic beacon GenServer
# - handle_info/2 paints ticks that tests can also assert_receive

defmodule PhoenixMultivitaminWeb.TaupoBeaconReceiveLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.TaupoBeacon

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Taupō beacon receive", "Hine", "Squirrel AS350")
      |> assign(:ticks, [])
      |> assign(:beacon_pid, nil)

    socket =
      if connected?(socket) do
        {:ok, pid} = TaupoBeacon.start_link("ZK-HNZ")
        :ok = TaupoBeacon.subscribe(pid)

        socket
        |> assign(:beacon_pid, pid)
        |> assign(:callsign, "ZK-HNZ")
      else
        assign(socket, :callsign, "ZK-HNZ")
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("ping_ash", _params, %{assigns: %{beacon_pid: pid}} = socket)
      when is_pid(pid) do
    TaupoBeacon.ping(pid, "ash plume drifting east of the caldera")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:taupo_beacon, callsign, note}, socket) do
    tick = "#{callsign}: #{note}"
    {:noreply, update(socket, :ticks, &[tick | &1])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 12 · Taupō beacon receive
      </p>

      <h1>Taupō beacon receive</h1>
      <p class="lede">
        Clerk {@clerk} listens for {@callsign} volcanic ticks on the {@craft}.
        Tests assert the same mailbox message with <code>assert_receive</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="callsign">{@callsign}</p>

      <button id="ping-ash" type="button" phx-click="ping_ash">Ping ash plume</button>

      <ul id="beacon-ticks">
        <li :for={{tick, index} <- Enum.with_index(@ticks)} id={"tick-#{index}"}>{tick}</li>
      </ul>
      <p :if={@ticks == []} id="empty-beacon">No volcanic ticks this watch.</p>
    </Layouts.app>
    """
  end
end
