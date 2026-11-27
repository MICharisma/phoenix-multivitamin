# Channels · 09 · Kotor bay radio room
#
# Teaches:
# - terminate/2 runs on leave, on a closed socket, and after handle_in/3 returns {:stop, reason, reply, socket}.
# - Multi-clause private functions turn {:shutdown, :left}, {:shutdown, :closed}, and custom reasons into words.
# - join/3 cannot broadcast; send(self(), :after_join) announces the operator once the socket is joined.
# - broadcast_from!/3 in terminate/2 tells everyone except the operator who left.
# - The JS client tells channel.leave(), socket.disconnect(code, reason), and onClose apart.

defmodule PhoenixMultivitaminWeb.KotorBayRadioRoomLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Kotor bay radio room",
       "Jelena Vujošević",
       "Air Montenegro Embraer 195 4O-AOA"
     )
     |> assign(positions: ["Tivat Tower", "Podgorica Approach", "Tivat Ground"])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 09 · Kotor bay radio room
      </p>

      <h1>Kotor bay radio room</h1>
      <p class="lede">
        Controller {@clerk} works the visual circling approach into Tivat between the bay and
        the Lovćen ridge for the {@craft}. Everyone in the room hears how each operator left.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="kotor-radio-room"
        class="scenario"
        phx-hook=".KotorRadioRoom"
        phx-update="ignore"
        data-socket-path="/features/17-channels/09-kotor-bay-radio-room/socket"
        data-operator={@clerk}
      >
        <select data-position>
          <option :for={position <- @positions} value={position}>{position}</option>
        </select>
        <div class="watch-actions">
          <button type="button" data-action="transmit">Transmit "4O-AOA, circle to land runway 32"</button>
          <button type="button" data-action="hand_over">Hand over to Marko</button>
          <button type="button" data-action="leave">Sign off the frequency</button>
          <button type="button" data-action="disconnect">Pull the headset</button>
        </div>
        <ol class="watch-log" data-room-log></ol>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".KotorRadioRoom">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.log = this.el.querySelector("[data-room-log]")
            this.tuneIn()
            this.el.querySelector("[data-position]").addEventListener("change", () => {
              this.socket.disconnect()
              this.tuneIn()
            })
            this.el.addEventListener("click", ({target: {dataset: {action}}}) => this.actions[action]?.())
            this.actions = {
              transmit: () => this.room.push("transmit", {call: "4O-AOA, circle to land runway 32"}),
              hand_over: () => this.room.push("hand_over", {relief: "Marko Radulović"})
                .receive("ok", ({relief}) => this.note(`Handed over to ${relief}.`)),
              leave: () => this.room.leave().receive("ok", () => this.note("Left the frequency.")),
              disconnect: () => this.socket.disconnect(() => this.note("Headset pulled."), 1000, "end of watch")
            }
          },
          tuneIn() {
            const position = this.el.querySelector("[data-position]").value
            this.socket = new Socket(this.el.dataset.socketPath, {params: {operator: this.el.dataset.operator, position}})
            this.socket.connect()
            this.room = this.socket.channel("kotor:radio_room")
            this.room.on("operator_on", ({operator, position}) => this.note(`${operator} on ${position}.`))
            this.room.on("operator_off", ({operator, position, why}) => this.note(`${operator} (${position}) ${why}.`))
            this.room.on("transmission", ({position, call}) => this.note(`${position}: ${call}`))
            this.room.onClose(() => this.note("Channel closed for this console."))
            this.room.onError(() => this.note("Channel errored; it will rejoin."))
            this.room.join()
          },
          note(text) {
            this.log.append(Object.assign(document.createElement("li"), {textContent: text}))
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
