# Telemetry and LiveDashboard · 09 · Maputo Indian Ocean wait
#
# Teaches:
# - Plug.Telemetry emits [:phoenix, :endpoint, :start] and [:phoenix, :endpoint, :stop]
# - The router emits [:phoenix, :router_dispatch, :start] and [:stop]
# - A connected LiveView can attach_many and surface the last stop duration

defmodule PhoenixMultivitaminWeb.MaputoIndianOceanWaitLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @endpoint_events [
    [:phoenix, :endpoint, :start],
    [:phoenix, :endpoint, :stop]
  ]

  @router_events [
    [:phoenix, :router_dispatch, :start],
    [:phoenix, :router_dispatch, :stop]
  ]

  @impl true
  def mount(_params, _session, socket) do
    probe_id = {__MODULE__, :maputo_probe, make_ref()}

    socket =
      socket
      |> assign_scenario("Maputo Indian Ocean wait", "Anchia", "Dash 8 Q400")
      |> assign(:harbour, "Maputo")
      |> assign(:ocean, "Indian Ocean")
      |> assign(:catalogued_events, catalogue_events())
      |> assign(:last_probe, nil)
      |> assign(:probe_log, [])
      |> assign(:listening?, false)
      |> assign(:probe_id, probe_id)

    socket =
      if connected?(socket) do
        events = @endpoint_events ++ @router_events

        case :telemetry.attach_many(probe_id, events, &__MODULE__.forward_probe/4, self()) do
          :ok ->
            assign(socket, :listening?, true)

          {:error, :already_exists} ->
            assign(socket, :listening?, true)
        end
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    _ = :telemetry.detach(socket.assigns.probe_id)
    :ok
  end

  @impl true
  def handle_event("clear_probe_log", _params, socket) do
    {:noreply, socket |> assign(:probe_log, []) |> assign(:last_probe, nil)}
  end

  def handle_event("mark_q400_ready", %{"stand" => stand}, socket) when stand != "" do
    entry = %{stand: stand, craft: "Dash 8 Q400", at: Time.utc_now() |> Time.truncate(:second)}

    {:noreply,
     update(socket, :probe_log, fn log ->
       Enum.take([Map.put(entry, :kind, :stand_mark) | log], 10)
     end)}
  end

  def handle_event("mark_q400_ready", _params, socket) do
    {:noreply, put_flash(socket, :error, "Anchia needs a stand before the Q400 is ready.")}
  end

  @impl true
  def handle_info({:maputo_probe, event, measurements, metadata}, socket) do
    probe = %{
      event: Enum.join(Enum.map(event, &to_string/1), "."),
      kind: List.last(event),
      duration_ms: duration_ms(measurements),
      route: metadata[:route],
      plug: metadata[:plug]
    }

    {:noreply,
     socket
     |> assign(:last_probe, probe)
     |> update(:probe_log, fn log -> Enum.take([probe | log], 12) end)}
  end

  def forward_probe(event, measurements, metadata, board) do
    send(board, {:maputo_probe, event, measurements, metadata})
  end

  defp catalogue_events do
    for event <- @endpoint_events ++ @router_events do
      dotted = Enum.join(Enum.map(event, &to_string/1), ".")

      %{
        name: dotted,
        dom_id: "event-" <> Enum.join(Enum.map(event, &to_string/1), "-"),
        family: event |> Enum.take(2) |> Enum.join("."),
        leaf: List.last(event)
      }
    end
  end

  defp duration_ms(%{duration: duration}) do
    System.convert_time_unit(duration, :native, :microsecond) / 1000
  end

  defp duration_ms(_), do: nil

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 09 · Maputo Indian Ocean wait
      </p>

      <h1>Maputo Indian Ocean wait</h1>
      <p class="lede">
        {@clerk} times Dash 8 Q400 turns at {@harbour} facing the {@ocean}.
        Built-in Phoenix endpoint and router_dispatch events fire on every HTTP
        request that reaches this board.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="listening-flag">
        {if(@listening?, do: "Attached to endpoint and router_dispatch", else: "Static mount")}
      </p>

      <div id="event-catalogue" class="scenario">
        <h2>Built-in events</h2>
        <ul>
          <li :for={event <- @catalogued_events} id={event.dom_id}>
            <code>{event.name}</code>
          </li>
        </ul>
      </div>

      <div class="watch-switcher">
        <button
          id="mark-stand-4"
          type="button"
          phx-click="mark_q400_ready"
          phx-value-stand="Stand 4"
        >
          Mark Stand 4 ready
        </button>
        <button id="clear-probe-log" type="button" phx-click="clear_probe_log">
          Clear probe log
        </button>
        <button id="mark-empty-stand" type="button" phx-click="mark_q400_ready" phx-value-stand="">
          Refuse empty stand
        </button>
      </div>

      <div id="last-probe" class="scenario">
        <h2>Last probe</h2>
        <%= if @last_probe do %>
          <p id="last-probe-event">{@last_probe.event}</p>
          <p :if={@last_probe.duration_ms} id="last-probe-duration">
            duration ≈ {Float.round(@last_probe.duration_ms, 3)} ms
          </p>
        <% else %>
          <p id="empty-probe">No endpoint or router probe yet on this socket.</p>
        <% end %>
      </div>

      <div id="probe-log" class="scenario">
        <h2>Probe log</h2>
        <ul>
          <li :for={{entry, index} <- Enum.with_index(@probe_log)} id={"probe-#{index}"}>
            <%= cond do %>
              <% match?(%{kind: :stand_mark}, entry) -> %>
                Stand mark · {entry.stand} · {entry.at}
              <% true -> %>
                {entry.event}
                <%= if entry.duration_ms do %>
                  · {Float.round(entry.duration_ms, 3)} ms
                <% end %>
            <% end %>
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
