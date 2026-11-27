# Channels · 03 · Brest Iroise orders
#
# Teaches:
# - handle_in/3 answers {:ok, map} and {:error, map}, a bare :ok, nothing at all, or a reply-then-stop.
# - is_map_key/2 guards pick the fluid clause; cond checks litres against a per-fluid ceiling.
# - The JS client wraps push/receive in a Promise so a form handler can await ok, error, or timeout.

defmodule PhoenixMultivitaminWeb.BrestIroiseOrdersLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Brest Iroise orders", "Erwan Guéguen", "HOP! ATR 72-600 F-HOPZ")
     |> assign(stand: "4", registration: "F-HOPZ")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 03 · Brest Iroise orders
      </p>

      <h1>Brest Iroise orders</h1>
      <p class="lede">
        De-icing coordinator {@clerk} orders glycol for the {@craft} on stand {@stand} while
        a sleet band crosses the Iroise toward Brest Bretagne.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="iroise-orders"
        class="scenario"
        phx-hook=".IroiseOrders"
        phx-update="ignore"
        data-socket-path="/features/17-channels/03-brest-iroise-orders/socket"
        data-stand={@stand}
        data-registration={@registration}
      >
        <form data-order-form>
          <label>
            Fluid
            <select name="fluid">
              <option value="type_i">Type I (heated, removal)</option>
              <option value="type_iv">Type IV (anti-icing)</option>
            </select>
          </label>
          <label>Litres <input name="litres" type="number" value="380" /></label>
          <button type="submit">Order fluid</button>
        </form>
        <button type="button" data-close-orders>Close orders for this departure</button>
        <ol class="watch-log" data-orders></ol>
        <p data-orders-lamp role="status">Connecting to the de-icing desk.</p>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".IroiseOrders">
        import {Socket} from "phoenix"

        const pushAsync = (channel, event, payload, timeout = 4000) =>
          new Promise((resolve, reject) => {
            channel.push(event, payload, timeout)
              .receive("ok", resolve)
              .receive("error", errors => reject({kind: "refused", errors}))
              .receive("timeout", () => reject({kind: "timeout"}))
          })

        export default {
          mounted() {
            const {socketPath, stand, registration} = this.el.dataset
            this.lamp = this.el.querySelector("[data-orders-lamp]")
            this.socket = new Socket(socketPath, {params: {stand}})
            this.socket.connect()
            this.orders = this.socket.channel(`iroise:deice:${registration}`)
            this.orders.join().receive("ok", () => this.lamp.textContent = `Desk open for ${registration}.`)

            this.el.querySelector("[data-order-form]").addEventListener("submit", async event => {
              event.preventDefault()
              const {fluid, litres} = Object.fromEntries(new FormData(event.target))
              try {
                const order = await pushAsync(this.orders, "order_fluid", {fluid, litres: Number(litres)})
                this.appendOrder(order)
                this.orders.push("truck_position", {bay: "glycol bay B"})
              } catch ({kind, errors}) {
                this.lamp.textContent = kind === "timeout"
                  ? "No answer from the de-icing desk."
                  : Object.values(errors).join("; ")
              }
            })

            this.el.querySelector("[data-close-orders]").addEventListener("click", async () => {
              const {orders, litres} = await pushAsync(this.orders, "close_orders", {})
              this.lamp.textContent = `Closed: ${orders} orders, ${litres} L.`
            })
          },
          appendOrder({order_no, fluid, litres}) {
            const line = document.createElement("li")
            line.textContent = `#${order_no} ${fluid.replace("_", " ").toUpperCase()} ${litres} L`
            this.el.querySelector("[data-orders]").append(line)
            this.lamp.textContent = `Order ${order_no} sent to the truck.`
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
