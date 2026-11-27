# Channels · 13 · Burgas Strandzha orders
#
# Teaches:
# - auth_token: true belongs on socket/3 itself; connect/3 then reads auth_token and user_agent from connect_info.
# - id/1 names only the tower sockets so a desk broadcast can drop every tower browser.
# - intercept ["drop_order"] lets handle_out/3 redact the discrete frequency for the lookout.
# - join/3 schedules :after_join so net_join is broadcast only after the socket is joined.
# - A second client on the same topic sees net_join and drop_order; the helicopter accepts with broadcast!.
# - The endpoint mounts both websocket and longpoll; the JS client picks one with the transport option.

defmodule PhoenixMultivitaminWeb.BurgasStrandzhaOrdersLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.BurgasStrandzhaSocket

  @crew [
    {"tower", "Burgas Tower · Nadezhda Ivanova"},
    {"helicopter", "Mi-17 CU-17 Strandzha"},
    {"lookout", "Malko Tarnovo lookout"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    watches =
      Map.new(@crew, fn {role, callsign} ->
        {role, BurgasStrandzhaSocket.sign_watch(role, callsign)}
      end)

    {:ok,
     socket
     |> assign_scenario(
       "Burgas Strandzha orders",
       "Nadezhda Ivanova",
       "Mi-17 CU-17 water-bomber"
     )
     |> assign(crew: @crew, watches: watches, shift: "afternoon")}
  end

  @impl true
  def handle_event("clear_tower", _params, socket) do
    PhoenixMultivitaminWeb.Endpoint.broadcast(
      "strandzha_tower:Burgas Tower · Nadezhda Ivanova",
      "disconnect",
      %{}
    )

    {:noreply, put_flash(socket, :info, "Tower sockets signed off.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 13 · Burgas Strandzha orders
      </p>

      <h1>Burgas Strandzha orders</h1>
      <p class="lede">
        Tower controller {@clerk} orders water drops for the {@craft} over Strandzha. Open a
        second tab as the helicopter or the Malko Tarnovo lookout to see the same topic
        rewritten per role.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="strandzha-orders"
        class="scenario"
        phx-hook=".StrandzhaOrders"
        phx-update="ignore"
        data-socket-path="/features/17-channels/13-burgas-strandzha-orders/socket"
        data-shift={@shift}
        data-watches={Jason.encode!(@watches)}
      >
        <label>
          Sign in as
          <select data-role>
            <option :for={{role, callsign} <- @crew} value={role}>{callsign}</option>
          </select>
        </label>
        <label>
          Transport
          <select data-transport>
            <option value="websocket">WebSocket</option>
            <option value="longpoll">LongPoll</option>
          </select>
        </label>
        <form data-order-form>
          <select name="landing_zone">
            <option>Sinemorets ridge</option>
            <option>Malko Tarnovo spur</option>
            <option>Strandzha peak</option>
          </select>
          <input name="loads" type="number" value="2" min="1" max="4" />
          <input name="fuel_state" value="45 minutes" />
          <input name="radio_discrete" value="122.450" />
          <button type="submit">Order drop</button>
        </form>
        <button type="button" data-accept disabled>Accept drop</button>
        <p data-orders-lamp role="status">Choose a role and transport.</p>
        <ol class="watch-log" data-orders></ol>
      </section>

      <button id="clear-tower" type="button" phx-click="clear_tower">
        Sign off every tower socket
      </button>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".StrandzhaOrders">
        import {Socket, LongPoll} from "phoenix"

        export default {
          mounted() {
            this.watches = JSON.parse(this.el.dataset.watches)
            this.lamp = this.el.querySelector("[data-orders-lamp]")
            this.accept = this.el.querySelector("[data-accept]")
            this.log = this.el.querySelector("[data-orders]")
            this.lastOrder = null

            const rolePicker = this.el.querySelector("[data-role]")
            const transportPicker = this.el.querySelector("[data-transport]")
            const retune = () => this.tuneIn(rolePicker.value, transportPicker.value)
            rolePicker.addEventListener("change", retune)
            transportPicker.addEventListener("change", retune)
            retune()

            this.el.querySelector("[data-order-form]").addEventListener("submit", event => {
              event.preventDefault()
              const form = Object.fromEntries(new FormData(event.target))
              this.drops.push("order_drop", {...form, loads: Number(form.loads)})
                .receive("ok", ({order_no, grid}) => this.lamp.textContent = `Order ${order_no} on grid ${grid}.`)
                .receive("error", ({reason}) => this.lamp.textContent = reason)
            })

            this.accept.addEventListener("click", () => {
              if (!this.lastOrder) return
              this.drops.push("accept_drop", {order_no: this.lastOrder})
            })
          },
          tuneIn(role, transportName) {
            this.socket?.disconnect()
            this.accept.disabled = role !== "helicopter"
            const transport = transportName === "longpoll" ? LongPoll : null
            this.socket = new Socket(this.el.dataset.socketPath, {
              authToken: this.watches[role],
              transport,
              longPollFallbackMs: transport ? undefined : 2500
            })
            this.socket.onOpen(() => this.lamp.textContent = `${role} on ${transportName}.`)
            this.socket.onError(() => this.lamp.textContent = "Strandzha net refused the auth token.")
            this.socket.connect()

            this.drops = this.socket.channel("strandzha:drops", {shift: this.el.dataset.shift})
            this.drops.on("net_join", ({role, callsign}) => this.note(`${callsign} (${role}) joined.`))
            this.drops.on("drop_order", order => {
              this.lastOrder = order.order_no
              const discrete = order.radio_discrete ? ` discrete ${order.radio_discrete}` : " (frequency redacted)"
              this.note(`Drop #${order.order_no} ${order.landing_zone} grid ${order.grid}: ${order.loads} loads${discrete}`)
            })
            this.drops.on("drop_accepted", ({order_no, by}) => this.note(`${by} accepted drop #${order_no}.`))
            this.drops.join()
              .receive("ok", ({callsign, user_agent}) => {
                this.lamp.textContent = `${callsign} via ${user_agent || "channel test"}.`
              })
              .receive("error", ({reason}) => this.lamp.textContent = reason)
          },
          note(text) {
            this.log.prepend(Object.assign(document.createElement("li"), {textContent: text}))
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
