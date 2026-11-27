# Channels · 10 · Ohrid lake talk
#
# Teaches:
# - channel "ohrid:*" routes every topic with that prefix; an exact "ohrid:tower" line above it wins first.
# - join/3 splits the topic and matches the segment list in private function heads.
# - A topic the socket has no channel line for never reaches a join/3.
# - The tower channel broadcasts into another topic with Endpoint.broadcast!/3.
# - The JS client keeps several channels on one socket in a Map and joins or leaves them by checkbox.

defmodule PhoenixMultivitaminWeb.OhridLakeTalkLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @sectors [
    {"ohrid:runway:02", "Runway 02"},
    {"ohrid:runway:20", "Runway 20"},
    {"ohrid:apron:1", "Stand 1"},
    {"ohrid:approach:lake", "Approach over the lake"},
    {"ohrid:approach:galicica", "Approach over Galičica"},
    {"ohrid:apron:9", "Stand 9 (not at Ohrid)"},
    {"struga:apron:1", "Struga apron (no channel)"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Ohrid lake talk", "Biljana Trajkovska", "Wizz Air A321neo HA-LVA")
     |> assign(sectors: @sectors)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 10 · Ohrid lake talk
      </p>

      <h1>Ohrid lake talk</h1>
      <p class="lede">
        Tower controller {@clerk} at Ohrid St. Paul the Apostle listens to several sectors at once
        while the {@craft} flies the approach over the lake.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="ohrid-lake-talk"
        class="scenario"
        phx-hook=".OhridLakeTalk"
        phx-update="ignore"
        data-socket-path="/features/17-channels/10-ohrid-lake-talk/socket"
        data-callsign="Ohrid Tower"
      >
        <fieldset>
          <legend>Sectors on the speaker</legend>
          <label :for={{topic, label} <- @sectors}>
            <input type="checkbox" value={topic} /> {label} <small data-state={topic}>closed</small>
          </label>
        </fieldset>
        <button type="button" data-close-sector="ohrid:approach:lake">Tower: close the lake approach</button>
        <ol class="watch-log" data-lake-log></ol>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".OhridLakeTalk">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.log = this.el.querySelector("[data-lake-log]")
            this.sectors = new Map()
            this.socket = new Socket(this.el.dataset.socketPath, {params: {callsign: this.el.dataset.callsign}})
            this.socket.connect()
            this.tower = this.socket.channel("ohrid:tower")
            this.tower.join()

            this.el.addEventListener("change", ({target: {value: topic, checked}}) => {
              checked ? this.listen(topic) : this.mute(topic)
            })
            this.el.querySelector("[data-close-sector]").addEventListener("click", ({target}) => {
              this.tower.push("close_sector", {sector: target.dataset.closeSector})
            })
          },
          listen(topic) {
            const sector = this.socket.channel(topic)
            sector.on("talk", ({callsign, words}) => this.note(`${topic} ${callsign}: ${words}`))
            sector.on("sector_closed", ({by}) => this.note(`${topic} closed by ${by}`))
            sector.join()
              .receive("ok", ({name, frequency}) => this.note(`Listening to ${name} on ${frequency}`))
              .receive("error", ({reason}) => {
                this.note(`${topic}: ${reason ?? "refused"}`)
                this.mute(topic)
              })
            this.sectors.set(topic, sector)
            this.paintStates()
          },
          mute(topic) {
            this.sectors.get(topic)?.leave()
            this.sectors.delete(topic)
            this.paintStates()
          },
          paintStates() {
            for (const marker of this.el.querySelectorAll("[data-state]")) {
              marker.textContent = this.sectors.get(marker.dataset.state)?.state ?? "closed"
            }
          },
          note(text) {
            this.log.prepend(Object.assign(document.createElement("li"), {textContent: text}))
            this.paintStates()
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
