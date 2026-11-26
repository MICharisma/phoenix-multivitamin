# Channels · 11 · Constanța Black Sea wire
#
# Teaches:
# - handle_in/3 receives {:binary, bytes} and pattern-matches a fixed-width tracker frame.
# - Clause order separates a bad heading, a wrong frame size, and a JSON payload that should be binary.
# - A reply can be {:ok, {:binary, bytes}}; a binary comprehension packs the platform table.
# - The JS client builds frames with DataView and reads ArrayBuffer replies.

defmodule PhoenixMultivitaminWeb.ConstantaBlackSeaWireLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Constanța Black Sea wire",
       "Andreea Popescu",
       "AW139 YR-BSA, ICAO 4A0F3C"
     )
     |> assign(icao: "4A0F3C")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 11 · Constanța Black Sea wire
      </p>

      <h1>Constanța Black Sea wire</h1>
      <p class="lede">
        Offshore flight follower {@clerk} at Mihail Kogălniceanu tracks the {@craft} out to the
        gas platforms. The tracker sends nine-byte binary frames, not JSON.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form
        id="black-sea-wire"
        class="scenario"
        phx-hook=".BlackSeaWire"
        phx-update="ignore"
        data-socket-path="/features/17-channels/11-constanta-black-sea-wire/socket"
        data-icao={@icao}
      >
        <label>Altitude (ft) <input name="altitude_ft" type="number" value="1500" /></label>
        <label>Heading (°) <input name="heading" type="number" value="112" /></label>
        <label>Fuel (kg) <input name="fuel_kg" type="number" value="620" /></label>
        <button type="submit">Send tracker frame</button>
        <button type="button" data-depths>Platform depths</button>
        <p data-wire-lamp role="status">Opening the Black Sea wire.</p>
        <ol class="watch-log" data-tracks></ol>
      </form>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".BlackSeaWire">
        import {Socket} from "phoenix"

        const packFrame = (icao, {altitude_ft, heading, fuel_kg}) => {
          const frame = new DataView(new ArrayBuffer(9))
          frame.setUint8(0, (icao >> 16) & 0xff)
          frame.setUint16(1, icao & 0xffff)
          frame.setUint16(3, altitude_ft)
          frame.setUint16(5, heading)
          frame.setUint16(7, fuel_kg)
          return frame.buffer
        }

        export default {
          mounted() {
            const lamp = this.el.querySelector("[data-wire-lamp]")
            const icao = parseInt(this.el.dataset.icao, 16)
            this.socket = new Socket(this.el.dataset.socketPath, {binaryType: "arraybuffer"})
            this.socket.connect()
            const wire = this.socket.channel("black_sea:tracks")
            wire.on("track", ({icao, altitude_ft, heading, fuel_kg, low_fuel}) => {
              const line = document.createElement("li")
              line.textContent = `${icao} ${altitude_ft} ft hdg ${String(heading).padStart(3, "0")} ${fuel_kg} kg${low_fuel ? " LOW FUEL" : ""}`
              this.el.querySelector("[data-tracks]").prepend(line)
            })
            wire.join().receive("ok", () => lamp.textContent = "Wire open.")

            this.el.addEventListener("submit", event => {
              event.preventDefault()
              const fields = Object.fromEntries([...new FormData(this.el)].map(([name, value]) => [name, Number(value)]))
              wire.push("frame", packFrame(icao, fields))
                .receive("ok", ack => {
                  const view = new DataView(ack)
                  lamp.textContent = `Frame ${view.getUint32(0)} acknowledged${view.getUint8(4) ? ", low fuel flagged" : ""}.`
                })
                .receive("error", ({reason}) => lamp.textContent = reason)
            })

            this.el.querySelector("[data-depths]").addEventListener("click", () => {
              wire.push("platform_depths", {}).receive("ok", table => {
                const view = new DataView(table)
                const depths = Array.from({length: view.getUint8(0)}, (_, index) => view.getUint16(1 + index * 2))
                lamp.textContent = `Platform water depths: ${depths.join(" m, ")} m.`
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
