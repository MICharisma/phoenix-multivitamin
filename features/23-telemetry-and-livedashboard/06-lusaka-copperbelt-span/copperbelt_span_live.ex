# Telemetry and LiveDashboard · 06 · Lusaka Copperbelt span
#
# Teaches:
# - A board listens for start, stop, and exception from one span prefix
# - Tagged tuples from the domain keep successful stows apart from load failures

defmodule PhoenixMultivitaminWeb.LusakaCopperbeltSpanLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.LusakaCopperbeltSpan

  @handler_id {__MODULE__, :copperbelt_board}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Lusaka Copperbelt span", "Mutale", "IL-76")
      |> assign(:apron, "Lusaka International")
      |> assign(:belt, "Copperbelt")
      |> assign(:events, [])
      |> assign(:last_result, nil)
      |> assign(:listening?, false)

    socket =
      if connected?(socket) do
        :ok =
          :telemetry.attach_many(
            @handler_id,
            [
              LusakaCopperbeltSpan.start_event(),
              LusakaCopperbeltSpan.stop_event(),
              LusakaCopperbeltSpan.exception_event()
            ],
            &__MODULE__.forward_span/4,
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
  def handle_event("stow_cargo", %{"cargo" => cargo, "tonnes" => tonnes}, socket) do
    tonnes =
      case Float.parse(String.trim(tonnes)) do
        {value, ""} -> value
        _ -> 0.0
      end

    socket =
      case LusakaCopperbeltSpan.load(cargo, tonnes) do
        %{status: :stowed} = result ->
          assign(socket, :last_result, {:stowed, result.cargo, result.tonnes})

        {:error, {:load_failed, reason}} ->
          socket
          |> assign(:last_result, {:failed, reason})
          |> put_flash(:error, reason)

        {:error, :empty_hold} ->
          put_flash(socket, :error, "Copperbelt tonnes must be positive before the IL-76 loads.")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:copperbelt_span, kind, measurements, metadata}, socket) do
    entry = %{
      kind: kind,
      cargo: metadata[:cargo],
      reason: metadata[:reason] && Exception.message(metadata[:reason]),
      kind_atom: metadata[:kind],
      has_stacktrace?: is_list(metadata[:stacktrace]),
      system_time?: Map.has_key?(measurements, :system_time),
      duration?: Map.has_key?(measurements, :duration)
    }

    {:noreply, update(socket, :events, fn events -> Enum.take([entry | events], 8) end)}
  end

  def forward_span([_, _, _, :start], measurements, metadata, pid) do
    send(pid, {:copperbelt_span, :start, measurements, metadata})
  end

  def forward_span([_, _, _, :stop], measurements, metadata, pid) do
    send(pid, {:copperbelt_span, :stop, measurements, metadata})
  end

  def forward_span([_, _, _, :exception], measurements, metadata, pid) do
    send(pid, {:copperbelt_span, :exception, measurements, metadata})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 06 · Lusaka Copperbelt span
      </p>

      <h1>Lusaka Copperbelt span</h1>
      <p class="lede">
        {@clerk} stows Copperbelt cargo on the {@craft} at {@apron}.
        A raising load emits <code>exception</code> instead of <code>stop</code>; start still fires.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="listening-flag">
        {if(@listening?, do: "Listening for start, stop, and exception", else: "Static mount")}
      </p>

      <div class="watch-switcher">
        <button
          id="stow-cathode"
          type="button"
          phx-click="stow_cargo"
          phx-value-cargo="copper cathode"
          phx-value-tonnes="28"
        >
          Stow copper cathode
        </button>
        <button
          id="stow-uncrated"
          type="button"
          phx-click="stow_cargo"
          phx-value-cargo="uncrated concentrate"
          phx-value-tonnes="12"
        >
          Refuse uncrated concentrate
        </button>
        <button
          id="stow-empty"
          type="button"
          phx-click="stow_cargo"
          phx-value-cargo="cobalt bags"
          phx-value-tonnes="0"
        >
          Refuse empty hold
        </button>
      </div>

      <div id="last-result" class="scenario">
        <h2>Last load</h2>
        <%= case @last_result do %>
          <% nil -> %>
            <p id="empty-result">No Copperbelt load yet.</p>
          <% {:stowed, cargo, tonnes} -> %>
            <p id="result-stowed">Stowed {cargo} · {tonnes} t</p>
          <% {:failed, reason} -> %>
            <p id="result-failed">{reason}</p>
        <% end %>
      </div>

      <div id="span-log" class="scenario">
        <h2>Span events</h2>
        <p :if={@events == []} id="empty-spans">No span has fired yet.</p>
        <ul>
          <li :for={{event, index} <- Enum.with_index(@events)} id={"span-#{index}"}>
            {event.kind}
            <%= if event.cargo do %>
              · {event.cargo}
            <% end %>
            <%= if event.kind_atom do %>
              · kind={inspect(event.kind_atom)}
            <% end %>
            <%= if event.has_stacktrace? do %>
              · stacktrace present
            <% end %>
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
