# Telemetry and LiveDashboard · 13 · Mayotte lagoon metrics
#
# Teaches:
# - Capstone: custom events, a full Telemetry.Metrics set, and handlers that send to self()
# - The app Telemetry supervisor exposes these metrics to LiveDashboard

defmodule PhoenixMultivitaminWeb.MayotteLagoonMetricsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MayotteLagoonMetrics

  @handler_id {__MODULE__, :lagoon_board}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Mayotte lagoon metrics", "Nazouati", "ATR 42-500")
      |> assign(:station, "Dzaoudzi–Pamandzi")
      |> assign(:metric_kinds, MayotteLagoonMetrics.metric_kinds())
      |> assign(:heard, [])
      |> assign(:depth, nil)
      |> assign(:listening?, false)

    socket =
      if connected?(socket) do
        :ok =
          :telemetry.attach_many(
            @handler_id,
            [
              MayotteLagoonMetrics.crossing_event(),
              MayotteLagoonMetrics.depth_event(),
              MayotteLagoonMetrics.clearance_event()
            ],
            &__MODULE__.forward_lagoon/4,
            self()
          )

        assign(socket, :listening?, true)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def terminate(_reason, _socket) do
    _ = :telemetry.detach(@handler_id)
    :ok
  end

  @impl true
  def handle_event("cross_ferry", _params, socket) do
    _ = MayotteLagoonMetrics.cross_ferry("Barbatura", 36)
    {:noreply, socket}
  end

  def handle_event("sound_depth", %{"metres" => metres}, socket) do
    metres =
      case Float.parse(metres) do
        {value, ""} -> value
        _ -> 0.0
      end

    socket =
      case MayotteLagoonMetrics.sound_depth(metres) do
        {:ok, depth} -> assign(socket, :depth, depth)
        {:error, :invalid_depth} -> put_flash(socket, :error, "Depth must be positive.")
      end

    {:noreply, socket}
  end

  def handle_event("clear_slot", _params, socket) do
    _ = MayotteLagoonMetrics.clear_slot("Quay Mangrove", 12)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:lagoon, kind, detail}, socket) do
    entry = %{kind: kind, detail: detail}

    {:noreply, update(socket, :heard, fn heard -> Enum.take([entry | heard], 8) end)}
  end

  def forward_lagoon([:mayotte, :lagoon, :ferry_crossing], %{passengers: n}, %{ferry: ferry}, pid) do
    send(pid, {:lagoon, :crossing, "#{ferry}: #{n} passengers"})
  end

  def forward_lagoon([:mayotte, :lagoon, :depth_metres], %{depth: depth}, _meta, pid) do
    send(pid, {:lagoon, :depth, "#{depth} m"})
  end

  def forward_lagoon(
        [:mayotte, :lagoon, :slot_clearance],
        %{duration: duration},
        %{quay: quay},
        pid
      ) do
    ms = System.convert_time_unit(duration, :native, :millisecond)
    send(pid, {:lagoon, :clearance, "#{quay}: #{ms} ms"})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 13 · Mayotte lagoon metrics
      </p>

      <h1>Mayotte lagoon metrics</h1>
      <p class="lede">
        {@clerk} keeps the pulse of {@station}: ferry crossings, lagoon depth, and quay
        clearances. The same metric structs feed LiveDashboard through the app Telemetry
        module.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="metric-kinds" class="scenario">
        <h2>Metric kinds on the dashboard</h2>
        <p id="kinds-list">{Enum.map_join(@metric_kinds, ", ", &Atom.to_string/1)}</p>
        <p id="listening-flag">
          {if(@listening?, do: "Lagoon handlers attached", else: "Static mount")}
        </p>
      </div>

      <div class="watch-switcher">
        <button id="cross-ferry" type="button" phx-click="cross_ferry">Cross Barbatura</button>
        <form id="depth-form" phx-submit="sound_depth">
          <input id="depth-input" type="text" name="metres" value="14.2" />
          <button id="sound-depth" type="submit">Sound depth</button>
        </form>
        <button id="clear-slot" type="button" phx-click="clear_slot">Clear Quay Mangrove</button>
      </div>

      <div id="lagoon-log" class="scenario">
        <h2>Handler log</h2>
        <p :if={@depth} id="current-depth">Depth: {@depth} m</p>
        <p :if={@heard == []} id="empty-log">No lagoon event heard yet.</p>
        <ul>
          <li :for={{entry, index} <- Enum.with_index(@heard)} id={"heard-#{index}"}>
            {entry.kind}: {entry.detail}
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
