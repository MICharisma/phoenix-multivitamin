# Telemetry and LiveDashboard · 08 · Gaborone Kalahari throughput
#
# Teaches:
# - Connected mount can start a short-period telemetry_poller via with/else
# - A board button bumps the Agent and calls measure_apron/0 once for an immediate sample
# - last_value metrics are defined beside the measurement MFA

defmodule PhoenixMultivitaminWeb.GaboroneKalahariThroughputLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.GaboroneKalahariThroughput

  @poller_name :gaborone_kalahari_apron_poller

  @impl true
  def mount(_params, _session, socket) do
    {:ok, _} = GaboroneKalahariThroughput.start_counter()

    socket =
      socket
      |> assign_scenario("Gaborone Kalahari throughput", "Keabetswe", "CRJ-900")
      |> assign(:apron, "Kalahari")
      |> assign(:station, "Gaborone Sir Seretse Khama")
      |> assign(:aircraft_on_apron, GaboroneKalahariThroughput.apron_count())
      |> assign(:samples, [])
      |> assign(:metric_card, GaboroneKalahariThroughput.describe_metric())
      |> assign(:poller_status, :idle)
      |> assign(:probe_id, {__MODULE__, :apron_probe, make_ref()})

    socket =
      if connected?(socket) do
        start_kalahari_poller(socket)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    _ = :telemetry.detach(socket.assigns.probe_id)

    case Process.whereis(@poller_name) do
      nil -> :ok
      pid -> GenServer.stop(pid, :normal)
    end
  end

  @impl true
  def handle_event("park_crj", _params, socket) do
    count = GaboroneKalahariThroughput.park_aircraft()
    sample = GaboroneKalahariThroughput.measure_apron()

    {:noreply,
     socket
     |> assign(:aircraft_on_apron, count)
     |> prepend_sample(sample, :manual)}
  end

  def handle_event("refuse_ghost_park", _params, socket) do
    {:noreply, put_flash(socket, :error, "Keabetswe will not park a ghost CRJ-900.")}
  end

  @impl true
  def handle_info({:apron_sample, aircraft}, socket) do
    {:noreply,
     socket
     |> assign(:aircraft_on_apron, aircraft)
     |> prepend_sample(aircraft, :poller)}
  end

  defp start_kalahari_poller(socket) do
    with {:ok, _pid} <-
           :telemetry_poller.start_link(
             measurements: [{GaboroneKalahariThroughput, :measure_apron, []}],
             period: 100,
             name: @poller_name
           ),
         :ok <- attach_board_probe(socket.assigns.probe_id) do
      assign(socket, :poller_status, :running)
    else
      {:error, {:already_started, _pid}} ->
        _ = attach_board_probe(socket.assigns.probe_id)
        assign(socket, :poller_status, :already_running)

      {:error, reason} ->
        assign(socket, :poller_status, {:failed, inspect(reason)})
    end
  end

  defp attach_board_probe(probe_id) do
    case :telemetry.attach(
           probe_id,
           GaboroneKalahariThroughput.event_name(),
           fn _event, %{aircraft: aircraft}, _meta, board ->
             send(board, {:apron_sample, aircraft})
           end,
           self()
         ) do
      :ok -> :ok
      {:error, :already_exists} -> :ok
    end
  end

  defp prepend_sample(socket, aircraft, source) do
    entry = %{
      aircraft: aircraft,
      source: source,
      at: Time.utc_now() |> Time.truncate(:second)
    }

    update(socket, :samples, fn samples -> Enum.take([entry | samples], 8) end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 08 · Gaborone Kalahari throughput
      </p>

      <h1>Gaborone Kalahari throughput</h1>
      <p class="lede">
        {@clerk} counts CRJ-900s on the {@apron} apron at {@station}. <code>telemetry_poller</code>
        calls <code>measure_apron/0</code>
        every 100 ms;
        that MFA reads an Agent and fires <code>:telemetry.execute/3</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="metric-card" class="scenario">
        <h2>last_value metric</h2>
        <p id="metric-name">{@metric_card.name}</p>
        <p id="metric-kind">kind={@metric_card.kind} measurement={@metric_card.measurement}</p>
        <p>{@metric_card.description}</p>
      </div>

      <p id="poller-status" data-status={poller_status_attr(@poller_status)}>
        {poller_status_label(@poller_status)}
      </p>
      <p id="apron-count">Aircraft on apron: {@aircraft_on_apron}</p>

      <div class="watch-switcher">
        <button id="park-crj" type="button" phx-click="park_crj">
          Park CRJ-900
        </button>
        <button id="refuse-ghost" type="button" phx-click="refuse_ghost_park">
          Refuse ghost park
        </button>
      </div>

      <div id="sample-log" class="scenario">
        <h2>Apron samples</h2>
        <p :if={@samples == []} id="empty-samples">No apron sample yet.</p>
        <ul>
          <li :for={{sample, index} <- Enum.with_index(@samples)} id={"sample-#{index}"}>
            {sample.aircraft} aircraft · {sample.source} · {sample.at}
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end

  defp poller_status_attr(:running), do: "running"
  defp poller_status_attr(:already_running), do: "already_running"
  defp poller_status_attr(:idle), do: "idle"
  defp poller_status_attr({:failed, _}), do: "failed"

  defp poller_status_label(:running), do: "Kalahari poller running (100 ms)"
  defp poller_status_label(:already_running), do: "Kalahari poller already running"
  defp poller_status_label(:idle), do: "Waiting for the socket before polling"
  defp poller_status_label({:failed, reason}), do: "Poller failed: #{reason}"
end
