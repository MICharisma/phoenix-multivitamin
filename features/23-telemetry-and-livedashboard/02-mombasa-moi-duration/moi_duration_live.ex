# Telemetry and LiveDashboard · 02 · Mombasa Moi duration
#
# Teaches:
# - A capture attaches to both start and stop events from one span prefix
# - Duration lives in stop measurements; start carries system_time

defmodule PhoenixMultivitaminWeb.MombasaMoiDurationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MombasaMoiTurnaround

  @handler_id {__MODULE__, :moi_span}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Mombasa Moi duration", "Juma", "B737-800")
      |> assign(:airport, "Moi International")
      |> assign(:spans, [])
      |> assign(:listening?, false)

    socket =
      if connected?(socket) do
        :ok =
          :telemetry.attach_many(
            @handler_id,
            [MombasaMoiTurnaround.start_event(), MombasaMoiTurnaround.stop_event()],
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
  def handle_event("clear_stand", %{"stand" => stand, "minutes" => minutes}, socket) do
    minutes = String.to_integer(minutes)

    socket =
      case MombasaMoiTurnaround.run(stand, minutes) do
        %{status: :cleared} = result ->
          assign(socket, :last_clearance, result)

        {:error, :non_positive_turnaround} ->
          put_flash(socket, :error, "Turnaround minutes must be positive.")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:moi_span, kind, measurements, metadata}, socket) do
    entry = %{
      kind: kind,
      stand: metadata[:stand],
      duration_ms: duration_ms(measurements),
      system_time?: Map.has_key?(measurements, :system_time),
      context?: Map.has_key?(metadata, :telemetry_span_context)
    }

    {:noreply, update(socket, :spans, fn spans -> Enum.take([entry | spans], 8) end)}
  end

  def forward_span([_, _, _, :start], measurements, metadata, pid) do
    send(pid, {:moi_span, :start, measurements, metadata})
  end

  def forward_span([_, _, _, :stop], measurements, metadata, pid) do
    send(pid, {:moi_span, :stop, measurements, metadata})
  end

  defp duration_ms(%{duration: duration}) do
    System.convert_time_unit(duration, :native, :millisecond)
  end

  defp duration_ms(_), do: nil

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 02 · Mombasa Moi duration
      </p>

      <h1>Mombasa Moi duration</h1>
      <p class="lede">
        {@clerk} clears turnarounds at {@airport}. <code>:telemetry.span/3</code> wraps each
        stand clearance so start and stop fire as a matched pair.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="listening-flag">
        {if(@listening?, do: "Listening for start and stop", else: "Static mount")}
      </p>

      <div class="watch-switcher">
        <button
          id="clear-stand-12"
          type="button"
          phx-click="clear_stand"
          phx-value-stand="Stand 12"
          phx-value-minutes="45"
        >
          Clear Stand 12 (45 min)
        </button>
        <button
          id="clear-stand-bad"
          type="button"
          phx-click="clear_stand"
          phx-value-stand="Stand 3"
          phx-value-minutes="0"
        >
          Refuse zero minutes
        </button>
      </div>

      <div id="span-log" class="scenario">
        <h2>Span events</h2>
        <p :if={@spans == []} id="empty-spans">No span has fired yet.</p>
        <ul>
          <li :for={{span, index} <- Enum.with_index(@spans)} id={"span-#{index}"}>
            {span.kind} · {span.stand}
            <%= if span.duration_ms do %>
              · {span.duration_ms} ms
            <% end %>
            <%= if span.context? do %>
              · context present
            <% end %>
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
