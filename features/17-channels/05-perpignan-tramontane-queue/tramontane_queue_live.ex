# Channels · 05 · Perpignan tramontane queue
#
# Teaches:
# - intercept/1 routes one broadcast event through handle_out/3 in every subscribed channel.
# - handle_out/3 guards on each socket's own crosswind limit: hold one departure, release another.
# - A LiveView form publishes with Endpoint.broadcast!/3; the channels never see the tower.
# - The JS client gives each departure strip a class with private fields and its own socket.

defmodule PhoenixMultivitaminWeb.PerpignanTramontaneQueueLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.PerpignanTramontaneChannel

  @departures [
    %{flight: "VY1471", type: "A320", label: "Vueling A320 to Barcelona"},
    %{flight: "T7 225", type: "Q400", label: "Twin Jet charter Q400 to Paris-Orly"},
    %{flight: "F-GTPC", type: "C172", label: "Aéroclub Cessna 172 to Carcassonne"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Perpignan tramontane queue",
       "Montserrat Puig",
       "Departure queue on runway 33"
     )
     |> assign(
       departures: @departures,
       posted_wind: nil,
       wind_form: to_form(%{"direction" => "290", "speed_kt" => "44"}, as: :wind)
     )}
  end

  @impl true
  def handle_event(
        "post_wind",
        %{"wind" => %{"direction" => direction, "speed_kt" => speed}},
        socket
      ) do
    with {direction, ""} when direction in 0..360 <- Integer.parse(direction),
         {speed, ""} when speed in 0..99 <- Integer.parse(speed) do
      wind = PerpignanTramontaneChannel.runway_wind(direction, speed)
      PhoenixMultivitaminWeb.Endpoint.broadcast!("tramontane:queue", "runway_wind", wind)
      {:noreply, assign(socket, :posted_wind, wind)}
    else
      _unreadable ->
        {:noreply, put_flash(socket, :error, "Wind must be ddd/ss in degrees and knots.")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 05 · Perpignan tramontane queue
      </p>

      <h1>Perpignan tramontane queue</h1>
      <p class="lede">
        Tower controller {@clerk} posts the tramontane at Perpignan–Rivesaltes. Every
        departure in the queue checks the crosswind against its own demonstrated limit.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.form for={@wind_form} id="tower-wind-form" phx-submit="post_wind">
        <.input field={@wind_form[:direction]} label="Wind direction (°)" />
        <.input field={@wind_form[:speed_kt]} label="Wind speed (kt)" />
        <button type="submit">Post runway wind</button>
      </.form>
      <p :if={@posted_wind} id="posted-wind">
        Runway {@posted_wind.runway}: {@posted_wind.wind}, crosswind {@posted_wind.crosswind_kt} kt
      </p>

      <ul
        id="tramontane-queue"
        class="watch-log"
        phx-hook=".TramontaneQueue"
        phx-update="ignore"
        data-socket-path="/features/17-channels/05-perpignan-tramontane-queue/socket"
      >
        <li :for={departure <- @departures} data-flight={departure.flight} data-type={departure.type}>
          <strong>{departure.flight}</strong> {departure.label} ·
          <span data-strip-state>joining</span>
        </li>
      </ul>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".TramontaneQueue">
        import {Socket} from "phoenix"

        class DepartureStrip {
          #socket
          #state

          constructor(strip, socketPath) {
            const {flight, type} = strip.dataset
            this.#state = strip.querySelector("[data-strip-state]")
            this.#socket = new Socket(socketPath)
            this.#socket.connect()
            const queue = this.#socket.channel("tramontane:queue", {flight, type})
            queue.on("runway_wind", wind => this.#release(wind))
            queue.on("hold_for_tramontane", hold => this.#hold(hold))
            queue.join().receive("ok", ({limit_kt}) => this.#show(`limit ${limit_kt} kt, awaiting wind`))
          }

          #release({runway, crosswind_kt, margin_kt}) {
            this.#show(`cleared to line up ${runway}, crosswind ${crosswind_kt} kt (${margin_kt} kt margin)`)
          }

          #hold({runway, exceeds_by_kt}) {
            this.#show(`holding: crosswind on ${runway} exceeds limit by ${exceeds_by_kt} kt`)
          }

          #show(text) {
            this.#state.textContent = text
          }

          disconnect() {
            this.#socket.disconnect()
          }
        }

        export default {
          mounted() {
            this.strips = [...this.el.querySelectorAll("[data-flight]")]
              .map(strip => new DepartureStrip(strip, this.el.dataset.socketPath))
          },
          destroyed() {
            this.strips.forEach(strip => strip.disconnect())
          }
        }
      </script>
    </Layouts.app>
    """
  end
end
