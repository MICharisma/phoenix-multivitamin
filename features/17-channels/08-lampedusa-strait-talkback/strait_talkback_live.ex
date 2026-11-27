# Channels · 08 · Lampedusa strait talkback
#
# Teaches:
# - join/3 builds its assigns from connect assigns, the topic, and the join payload.
# - A guard on is_map_key/2 defaults a missing last_seq by calling join/3 again.
# - The reply replays only transmissions after last_seq; handle_in/3 accepts acknowledgements in order.
# - The JS client passes join params as a closure, so every rejoin sends the latest acknowledged seq.

defmodule PhoenixMultivitaminWeb.LampedusaStraitTalkbackLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Lampedusa strait talkback",
       "Rosaria Matina",
       "Guardia Costiera ATR 42MP Manta 10-01"
     )
     |> assign(console: "MRCC Roma")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 08 · Lampedusa strait talkback
      </p>

      <h1>Lampedusa strait talkback</h1>
      <p class="lede">
        Coordinator {@clerk} at {@console} acknowledges each transmission from the {@craft} over the Strait of Sicily. After a dropped link, only unacknowledged calls replay.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="strait-talkback"
        class="scenario"
        phx-hook=".StraitTalkback"
        phx-update="ignore"
        data-socket-path="/features/17-channels/08-lampedusa-strait-talkback/socket"
        data-operator={@clerk}
        data-console={@console}
      >
        <ol class="watch-log" data-transmissions></ol>
        <button type="button" data-drop-link>Drop the link</button>
        <p data-talkback-lamp role="status">Joining the strait talkback.</p>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".StraitTalkback">
        import {Socket} from "phoenix"

        const storageKey = "lampedusa-strait-acknowledged-seq"

        export default {
          mounted() {
            const {socketPath, operator, console: consoleName} = this.el.dataset
            this.lamp = this.el.querySelector("[data-talkback-lamp]")
            this.list = this.el.querySelector("[data-transmissions]")
            this.lastSeq = Number(sessionStorage.getItem(storageKey) ?? 0)

            this.socket = new Socket(socketPath, {
              params: {operator, console: consoleName},
              reconnectAfterMs: tries => [400, 1200, 3000][tries - 1] ?? 6000
            })
            this.socket.onClose(() => this.lamp.textContent = "Link lost; reconnecting.")
            this.socket.connect()

            this.talkback = this.socket.channel("strait:talkback", () => ({last_seq: this.lastSeq}))
            this.talkback.join().receive("ok", reply => this.replay(reply))

            this.list.addEventListener("click", ({target}) => {
              const seq = Number(target.closest("[data-seq]")?.dataset.seq)
              if (!seq) return
              this.talkback.push("acknowledge", {seq})
                .receive("ok", ({acknowledged_seq}) => {
                  this.lastSeq = acknowledged_seq
                  sessionStorage.setItem(storageKey, acknowledged_seq)
                  target.closest("li").remove()
                })
                .receive("error", ({expected_seq}) => this.lamp.textContent = `Acknowledge ${expected_seq} first.`)
            })

            this.el.querySelector("[data-drop-link]").addEventListener("click", () => {
              this.socket.disconnect(() => setTimeout(() => this.socket.connect(), 800))
            })
          },
          replay({missed, head_seq, signature}) {
            this.list.replaceChildren(...missed.map(({seq, station, text}) => {
              const line = document.createElement("li")
              line.dataset.seq = seq
              line.textContent = `${seq}/${head_seq} ${station}: ${text} (click to acknowledge)`
              return line
            }))
            this.lamp.textContent = `${signature}: ${missed.length} unacknowledged after #${this.lastSeq}.`
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
