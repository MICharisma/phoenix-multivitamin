# Telemetry and LiveDashboard · 04 · Kilimanjaro Kibo cycle
#
# Teaches:
# - :telemetry.attach_many/4 binds one handler id to several event names
# - :telemetry.detach/1 removes that id for every event at once
# - A handler that raises is detached by telemetry; later events stay silent

defmodule PhoenixMultivitaminWeb.KilimanjaroKiboCycleLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.KilimanjaroKiboCycle

  @handler_id {__MODULE__, :kibo_board}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Kilimanjaro Kibo cycle", "Neema", "Cessna Caravan")
      |> assign(:station, "Kilimanjaro International")
      |> assign(:peak, "Kibo")
      |> assign(:heard, MapSet.new())
      |> assign(:legs, [])
      |> assign(:listening?, false)

    socket =
      if connected?(socket) do
        :ok =
          :telemetry.attach_many(
            @handler_id,
            KilimanjaroKiboCycle.event_names(),
            &__MODULE__.forward_leg/4,
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
  def handle_event("fly_leg", %{"phase" => phase, "altitude" => altitude}, socket) do
    phase_atom = String.to_existing_atom(phase)
    altitude_ft = String.to_integer(altitude)

    socket =
      case KilimanjaroKiboCycle.fly(phase_atom, altitude_ft) do
        {:ok, _leg} ->
          socket

        {:error, :grounded} ->
          put_flash(socket, :error, "The Caravan needs a positive altitude before it climbs.")
      end

    {:noreply, socket}
  end

  def handle_event("fly_leg", _params, socket) do
    {:noreply, put_flash(socket, :error, "Name the Kibo phase before Neema clears the leg.")}
  end

  @impl true
  def handle_info({:kibo_leg, phase, altitude_ft}, socket) do
    socket =
      socket
      |> update(:heard, &MapSet.put(&1, phase))
      |> update(:legs, fn legs ->
        entry = %{phase: phase, altitude_ft: altitude_ft}
        Enum.take([entry | legs], 6)
      end)

    {:noreply, socket}
  end

  def forward_leg([:kilimanjaro, :kibo, phase], %{altitude_ft: altitude_ft}, _metadata, pid) do
    send(pid, {:kibo_leg, phase, altitude_ft})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 04 · Kilimanjaro Kibo cycle
      </p>

      <h1>Kilimanjaro Kibo cycle</h1>
      <p class="lede">
        {@clerk} logs Caravan legs around {@peak} from {@station}.
        <code>:telemetry.attach_many/4</code> listens to ascent, descent, and summit under one id.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="listening-flag">
        {if(@listening?, do: "Listening on attach_many", else: "Static mount")}
      </p>

      <p id="heard-phases">
        Heard: {Enum.map_join(MapSet.to_list(@heard), ", ", &Atom.to_string/1) |> blank_as_none()}
      </p>

      <div class="watch-switcher">
        <button
          id="fly-ascent"
          type="button"
          phx-click="fly_leg"
          phx-value-phase="ascent"
          phx-value-altitude="12000"
        >
          Ascent 12 000 ft
        </button>
        <button
          id="fly-summit"
          type="button"
          phx-click="fly_leg"
          phx-value-phase="summit"
          phx-value-altitude="19341"
        >
          Summit Uhuru
        </button>
        <button
          id="fly-descent"
          type="button"
          phx-click="fly_leg"
          phx-value-phase="descent"
          phx-value-altitude="8000"
        >
          Descent 8 000 ft
        </button>
        <button
          id="fly-grounded"
          type="button"
          phx-click="fly_leg"
          phx-value-phase="ascent"
          phx-value-altitude="0"
        >
          Refuse grounded climb
        </button>
      </div>

      <div id="leg-log" class="scenario">
        <h2>Heard legs</h2>
        <p :if={@legs == []} id="empty-legs">No Kibo leg has fired yet.</p>
        <ul>
          <li :for={leg <- @legs} id={"leg-#{leg.phase}"}>
            {leg.phase} · {leg.altitude_ft} ft
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end

  defp blank_as_none(""), do: "none"
  defp blank_as_none(text), do: text
end
