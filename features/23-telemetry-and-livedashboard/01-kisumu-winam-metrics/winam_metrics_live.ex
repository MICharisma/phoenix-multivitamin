# Telemetry and LiveDashboard · 01 · Kisumu Winam metrics
#
# Teaches:
# - :telemetry.attach/4 registers a handler MFA with opaque config
# - :telemetry.detach/1 removes that handler; duplicate ids return {:error, :already_exists}
# - with/else branches the attach result before the board opens

defmodule PhoenixMultivitaminWeb.KisumuWinamMetricsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.KisumuWinamEmitter

  @handler_id {__MODULE__, :winam_board}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Kisumu Winam metrics", "Achieng", "DHC-8-400")
      |> assign(:station, "Kisumu International")
      |> assign(:gulf, "Winam Gulf")
      |> assign(:crossings, [])
      |> assign(:handler_status, :idle)
      |> assign(:attach_error, nil)
      |> assign(:handler_ref, @handler_id)

    socket =
      if connected?(socket) do
        case attach_board_handler() do
          :ok ->
            assign(socket, :handler_status, :attached)

          {:error, :already_exists} ->
            socket
            |> assign(:handler_status, :duplicate)
            |> assign(:attach_error, "already_exists")
        end
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
  def handle_event("cross_ferry", %{"ferry" => ferry}, socket) do
    crossing = %KisumuWinamEmitter{ferry: ferry, passengers: passenger_count(ferry)}

    socket =
      case KisumuWinamEmitter.cross(crossing) do
        {:ok, _passengers} ->
          socket

        {:error, :empty_crossing} ->
          put_flash(socket, :error, "The #{ferry} has no passengers to count.")
      end

    {:noreply, socket}
  end

  def handle_event("cross_ferry", _params, socket) do
    {:noreply, put_flash(socket, :error, "Name the ferry before it leaves the pier.")}
  end

  @impl true
  def handle_info({:winam_crossing, ferry, passengers}, socket) do
    {:noreply, prepend_crossing(socket, ferry, passengers)}
  end

  defp attach_board_handler do
    :telemetry.attach(
      @handler_id,
      KisumuWinamEmitter.event_name(),
      &__MODULE__.handle_winam_event/4,
      %{board: self()}
    )
  end

  def handle_winam_event(_event, %{passengers: passengers}, %{ferry: ferry}, %{board: board}) do
    send(board, {:winam_crossing, ferry, passengers})
  end

  defp passenger_count("MV Mbita"), do: 42
  defp passenger_count("MV Rusinga"), do: 28
  defp passenger_count(_ferry), do: 0

  defp prepend_crossing(socket, ferry, passengers) do
    entry = %{ferry: ferry, passengers: passengers, at: Time.utc_now() |> Time.truncate(:second)}

    update(socket, :crossings, fn crossings -> [entry | crossings] |> Enum.take(6) end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 01 · Kisumu Winam metrics
      </p>

      <h1>Kisumu Winam metrics</h1>
      <p class="lede">
        {@clerk} watches lake ferries leave {@station} across the {@gulf}. Each crossing
        fires <code>:telemetry.execute/3</code>; the board listens with <code>:telemetry.attach/4</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="scenario">
        <h2>Handler</h2>
        <p id="handler-status" data-status={@handler_status}>
          <%= case @handler_status do %>
            <% :attached -> %>
              Attached as {inspect(@handler_ref)}
            <% :duplicate -> %>
              Attach refused: {@attach_error}
            <% :idle -> %>
              Waiting for the socket before attaching
          <% end %>
        </p>
      </div>

      <div class="watch-switcher">
        <button id="cross-mbita" type="button" phx-click="cross_ferry" phx-value-ferry="MV Mbita">
          Cross MV Mbita
        </button>
        <button
          id="cross-rusinga"
          type="button"
          phx-click="cross_ferry"
          phx-value-ferry="MV Rusinga"
        >
          Cross MV Rusinga
        </button>
        <button id="cross-empty" type="button" phx-click="cross_ferry" phx-value-ferry="MV Empty">
          Refuse empty hull
        </button>
      </div>

      <div id="crossing-log" class="scenario">
        <h2>Heard crossings</h2>
        <p :if={@crossings == []} id="empty-crossings">No ferry has reported yet.</p>
        <ul>
          <li :for={crossing <- @crossings} id={"crossing-#{crossing.ferry}"}>
            {crossing.ferry}: {crossing.passengers} passengers at {crossing.at}
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
