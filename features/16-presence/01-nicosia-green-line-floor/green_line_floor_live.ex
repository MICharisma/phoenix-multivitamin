# Presence · 01 · Nicosia Green Line floor
#
# Teaches:
# - Presence.track/4 runs only on the connected mount; the disconnected render has no process worth tracking.
# - The floor subscribes to the same topic it tracks on and re-reads Presence.list/1 for each presence_diff.
# - Query params pick the controller and sector, with a guarded default for an unknown sector.

defmodule PhoenixMultivitaminWeb.NicosiaGreenLineFloorLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:nicosia-acc-floor"
  @sectors ["Nicosia East", "Nicosia West", "Larnaca Approach", "Paphos Approach"]

  @impl true
  def mount(params, _session, socket) do
    controller = Map.get(params, "controller", "Andreas")
    sector = sector_from(params)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

      {:ok, _ref} =
        Presence.track(self(), @topic, controller, %{
          sector: sector,
          signed_on_at: DateTime.utc_now() |> DateTime.truncate(:second)
        })
    end

    {:ok,
     socket
     |> assign_scenario("Nicosia Green Line floor", controller, "Cyprus Airways A220-300")
     |> assign(sector: sector, console_live?: connected?(socket))
     |> assign_floor()}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply, assign_floor(socket)}
  end

  defp sector_from(%{"sector" => sector}) when sector in @sectors, do: sector
  defp sector_from(_params), do: "Nicosia East"

  defp assign_floor(socket) do
    on_floor =
      for {controller, %{metas: [first_console | _]}} <- Presence.list(@topic) do
        {controller, first_console.sector}
      end

    assign(socket, :on_floor, Enum.sort(on_floor))
  end

  defp dom_id(controller), do: "floor-" <> String.downcase(controller)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 01 · Nicosia Green Line floor
      </p>

      <h1>Nicosia Green Line floor</h1>
      <p class="lede">
        {@clerk} signs on to {@sector} at the Nicosia control centre while a {@craft} climbs out of
        Larnaca. The floor list shows every controller whose console is connected right now.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section class="scenario mt-6">
        <h2>On the floor</h2>
        <p :if={!@console_live?} id="floor-pending">
          The floor list opens when your console connects.
        </p>
        <ul id="floor-list" class="watch-log">
          <li :for={{controller, sector} <- @on_floor} id={dom_id(controller)}>
            <strong>{controller}</strong> · {sector}
          </li>
        </ul>
      </section>
    </Layouts.app>
    """
  end
end
