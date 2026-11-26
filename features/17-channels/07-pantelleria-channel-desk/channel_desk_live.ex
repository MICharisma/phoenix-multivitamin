# Channels · 07 · Pantelleria channel desk
#
# Teaches:
# - join/3 sends itself :after_join, so the wind table is pushed only after the join reply.
# - handle_info/2 pushes on a Process.send_after/3 cadence that the join payload clamps.
# - Repeating `generation` in one function head drops a stale tick after pause_sampling.
# - with/1 chains two guarded matches to decide whether a headwind change is windshear.
# - The JS client registers handlers from an object map and draws an SVG polyline.

defmodule PhoenixMultivitaminWeb.PantelleriaChannelDeskLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Pantelleria channel desk", "Salvatore Gabriele", "DAT ATR 42-500 I-ADLV")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 07 · Pantelleria channel desk
      </p>

      <h1>Pantelleria channel desk</h1>
      <p class="lede">
        Forecaster {@clerk} watches three anemometers across Pantelleria's ridge while the {@craft} holds over the Sicily Channel for a gap in the shear.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="pantelleria-desk"
        class="scenario"
        phx-hook=".PantelleriaDesk"
        phx-update="ignore"
        data-socket-path="/features/17-channels/07-pantelleria-channel-desk/socket"
        data-cadence-ms="1500"
      >
        <h2 data-runway>Runway</h2>
        <svg viewBox="0 0 120 40" width="360" height="120" role="img" aria-label="Headwind trace">
          <polyline data-trace fill="none" stroke="#1f3d2b" stroke-width="1.5" points="" />
        </svg>
        <button type="button" data-toggle-sampling>Pause sampling</button>
        <p data-desk-lamp role="status">Joining the anemometer channel.</p>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".PantelleriaDesk">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.headwinds = []
            this.sampling = true
            const lamp = this.el.querySelector("[data-desk-lamp]")
            this.socket = new Socket(this.el.dataset.socketPath, {heartbeatIntervalMs: 15000})
            this.socket.connect()
            const desk = this.socket.channel("pantelleria:anemometers", {cadence_ms: Number(this.el.dataset.cadenceMs)})

            const handlers = {
              wind_table: ({runway, sensors, shear_kt}) => {
                this.el.querySelector("[data-runway]").textContent =
                  `Runway ${runway}: ${sensors.length} sensors, shear at ${shear_kt} kt`
              },
              anemometer: ({sensor, headwind_kt}) => {
                this.headwinds = [...this.headwinds, headwind_kt].slice(-24)
                this.el.querySelector("[data-trace]").setAttribute("points",
                  this.headwinds.map((knots, index) => `${index * 5},${40 - knots}`).join(" "))
                lamp.textContent = `${sensor}: ${headwind_kt} kt headwind`
              },
              windshear_alert: ({sensor, change_kt}) => {
                lamp.textContent = `WINDSHEAR ${sensor}: ${change_kt > 0 ? "+" : ""}${change_kt} kt`
              }
            }
            Object.entries(handlers).forEach(([event, handler]) => desk.on(event, handler))
            desk.join()

            const toggle = this.el.querySelector("[data-toggle-sampling]")
            toggle.addEventListener("click", () => {
              desk.push(this.sampling ? "pause_sampling" : "resume_sampling", {}).receive("ok", () => {
                this.sampling = !this.sampling
                toggle.textContent = this.sampling ? "Pause sampling" : "Resume sampling"
              })
            })
          },
          destroyed() {
            this.socket.disconnect()
          }
        }
      </script>
    </Layouts.app>
    """
  end
end
