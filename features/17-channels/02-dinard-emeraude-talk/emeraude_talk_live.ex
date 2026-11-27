# Channels · 02 · Dinard Émeraude talk
#
# Teaches:
# - join/3 matches "emeraude:stand:" <> stand and authorizes it against the crew assigned on connect.
# - A guard rejects unknown stands; cond explains which rule a rostered crew member broke.
# - {:error, reply} refuses the join; the JS client must leave() or it keeps rejoining the stand.
# - handle_in/3 matches the crew role in the socket assigns before calling chocks.

defmodule PhoenixMultivitaminWeb.DinardEmeraudeTalkLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.DinardEmeraudeSocket

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Dinard Émeraude talk",
       "Gwenaëlle Le Bihan",
       "Ryanair Boeing 737-800 EI-DCL"
     )
     |> assign(badges: DinardEmeraudeSocket.badges(), stands: ~w(1 2 3 4), flight: "FR5482")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 02 · Dinard Émeraude talk
      </p>

      <h1>Dinard Émeraude talk</h1>
      <p class="lede">
        Ramp lead {@clerk} reports to a stand at Dinard–Pleurtuy for the {@craft} turnaround.
        The stand channel only admits crew rostered on that stand.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form
        id="emeraude-talk"
        class="scenario"
        phx-hook=".EmeraudeTalk"
        phx-update="ignore"
        data-socket-path="/features/17-channels/02-dinard-emeraude-talk/socket"
      >
        <label>
          Badge
          <select name="badge">
            <option :for={badge <- @badges} value={badge}>{badge}</option>
          </select>
        </label>
        <label>
          Stand
          <select name="stand">
            <option :for={stand <- @stands} value={stand}>Stand {stand}</option>
          </select>
        </label>
        <label>Turnaround <input name="turnaround" value={@flight} /></label>
        <button type="submit">Report to stand</button>
        <button type="button" data-chocks disabled>Chocks on</button>
        <p data-stand-lamp role="status">Not on a stand.</p>
      </form>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".EmeraudeTalk">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.lamp = this.el.querySelector("[data-stand-lamp]")
            this.chocks = this.el.querySelector("[data-chocks]")
            this.el.addEventListener("submit", event => {
              event.preventDefault()
              const {badge, stand, turnaround} = Object.fromEntries(new FormData(this.el))
              this.reportTo(badge, stand, turnaround)
            })
            this.chocks.addEventListener("click", () => {
              this.stand?.push("chocks_on", {})
                .receive("ok", () => this.lamp.textContent = "Chocks on, called to the stand.")
                .receive("error", ({reason}) => this.lamp.textContent = reason)
            })
          },
          reportTo(badge, stand, turnaround) {
            this.socket?.disconnect()
            this.chocks.disabled = true
            this.socket = new Socket(this.el.dataset.socketPath, {params: {badge}, rejoinAfterMs: () => 4000})
            this.socket.connect()
            this.stand = this.socket.channel(`emeraude:stand:${stand}`, {turnaround})
            this.stand.on("chocks_on", ({flight, by}) => this.lamp.textContent = `${by}: chocks on ${flight}.`)
            this.stand.join(3000)
              .receive("ok", ({crew, flight}) => {
                this.chocks.disabled = false
                this.lamp.textContent = `${crew} on stand ${stand} for ${flight}.`
              })
              .receive("error", ({reason}) => {
                this.lamp.textContent = reason
                this.stand.leave()
              })
              .receive("timeout", () => this.lamp.textContent = "Stand did not answer; check the badge.")
          },
          destroyed() {
            this.socket?.disconnect()
          }
        }
      </script>
    </Layouts.app>
    """
  end
end
