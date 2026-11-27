# Presence · 06 · Ljubljana Triple Bridge relief
#
# Teaches:
# - Presence.update/4 with a function rewrites the tracked meta in place; the key and process stay the same.
# - Guarded handle_event clauses accept only known relief statuses and flash the rejected one.
# - An updated meta carries phx_ref_prev, which the board uses to mark a changed status.

defmodule PhoenixMultivitaminWeb.LjubljanaTripleBridgeReliefLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:ljubljana-tower-relief"
  @statuses %{
    "on_position" => "On position",
    "briefing_relief" => "Briefing the relief",
    "on_break" => "On break"
  }

  @impl true
  def mount(params, _session, socket) do
    controller = params["controller"] || "Mojca"

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

      {:ok, _ref} =
        Presence.track(self(), @topic, controller, %{status: "on_position", changes: 0})
    end

    {:ok,
     socket
     |> assign_scenario("Ljubljana Triple Bridge relief", controller, "LOT Embraer 195")
     |> assign(:statuses, @statuses)
     |> assign_board()}
  end

  @impl true
  def handle_event("set_status", %{"status" => status}, socket)
      when is_map_key(@statuses, status) do
    {:ok, _ref} =
      Presence.update(self(), @topic, socket.assigns.clerk, fn meta ->
        %{meta | status: status, changes: meta.changes + 1}
      end)

    {:noreply, socket}
  end

  def handle_event("set_status", %{"status" => status}, socket) do
    {:noreply, put_flash(socket, :error, "#{status} is not a relief status.")}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, assign_board(socket)}

  defp assign_board(socket) do
    board =
      @topic
      |> Presence.list()
      |> Enum.map(fn {controller, %{metas: [meta | _]}} ->
        %{
          controller: controller,
          status: @statuses[meta.status],
          changed?: Map.has_key?(meta, :phx_ref_prev)
        }
      end)
      |> Enum.sort_by(& &1.controller)

    assign(socket, :board, board)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 06 · Ljubljana Triple Bridge relief
      </p>

      <h1>Ljubljana Triple Bridge relief</h1>
      <p class="lede">
        {@clerk} hands over Ljubljana tower while a {@craft} lines up on runway 30. Each controller
        updates their relief status on the shared board without signing off.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="status-buttons" class="scenario mt-6 flex flex-wrap gap-2">
        <button
          :for={{status, label} <- @statuses}
          id={"status-#{status}"}
          type="button"
          phx-click="set_status"
          phx-value-status={status}
          class="rounded-lg border border-stone-300 px-3 py-1 transition hover:bg-stone-100"
        >
          {label}
        </button>
      </div>

      <table id="relief-board" class="mt-6">
        <tr :for={row <- @board} id={"relief-#{String.downcase(row.controller)}"}>
          <th>{row.controller}</th>
          <td>{row.status}</td>
          <td :if={row.changed?} class="status-changed">updated</td>
        </tr>
      </table>
    </Layouts.app>
    """
  end
end
