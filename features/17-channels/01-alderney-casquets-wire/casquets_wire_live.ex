# Channels · 01 · Alderney Casquets wire
#
# Teaches:
# - connect/3 verifies a signed Phoenix.Token from the client params before any channel joins.
# - connect/3 can refuse with :error or with {:error, reason}; an expired shift is not a missing one.
# - id/1 names every socket of one desk, so a "disconnect" broadcast to that id drops them all.
# - The JS client reads params from a closure on every reconnect, so a cleared token stays out.

defmodule PhoenixMultivitaminWeb.AlderneyCasquetsWireLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.AlderneyCasquetsSocket

  @desk "north"

  @impl true
  def mount(_params, _session, socket) do
    dispatcher = "Morwenna Le Page"

    {:ok,
     socket
     |> assign_scenario("Alderney Casquets wire", dispatcher, "Aurigny Dornier 228 G-SAYE")
     |> assign(
       desk: @desk,
       shift_token: AlderneyCasquetsSocket.sign_shift(dispatcher, @desk),
       signed_off?: false
     )}
  end

  @impl true
  def handle_event("sign_off_desk", _params, %{assigns: %{desk: desk}} = socket) do
    PhoenixMultivitaminWeb.Endpoint.broadcast(
      AlderneyCasquetsSocket.desk_topic(desk),
      "disconnect",
      %{}
    )

    {:noreply, assign(socket, signed_off?: true, shift_token: "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 01 · Alderney Casquets wire
      </p>

      <h1>Alderney Casquets wire</h1>
      <p class="lede">
        Dispatcher {@clerk} opens the Casquets weather wire on the {@desk} desk before
        clearing the {@craft} into Alderney's short grass-edged runway.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="casquets-wire"
        class="scenario"
        phx-hook=".CasquetsWire"
        phx-update="ignore"
        data-socket-path="/features/17-channels/01-alderney-casquets-wire/socket"
        data-shift-token={@shift_token}
      >
        <h2>Casquets wire</h2>
        <p data-wire-lamp role="status">Wire closed.</p>
        <dl class="station-meta" data-reading></dl>
      </section>

      <button id="sign-off-desk" type="button" phx-click="sign_off_desk" disabled={@signed_off?}>
        {if(@signed_off?, do: "North desk signed off", else: "Sign off the north desk")}
      </button>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".CasquetsWire">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.lamp = this.el.querySelector("[data-wire-lamp]")
            this.socket = new Socket(this.el.dataset.socketPath, {
              params: () => ({shift_token: this.el.dataset.shiftToken}),
              logger: (kind, msg, data) => console.debug(`casquets ${kind}: ${msg}`, data)
            })
            this.socket.onOpen(() => this.lamp.textContent = "Wire open.")
            this.socket.onError(() => this.lamp.textContent = "Wire refused or dropped; retrying.")
            this.socket.connect()

            this.socket.channel("casquets:wire").join()
              .receive("ok", ({dispatcher, desk, reading}) => {
                this.lamp.textContent = `${dispatcher} on the ${desk} desk.`
                this.el.querySelector("[data-reading]").replaceChildren(
                  ...Object.entries(reading).flatMap(([label, value]) => {
                    const term = document.createElement("dt")
                    const detail = document.createElement("dd")
                    term.textContent = label.replaceAll("_", " ")
                    detail.textContent = value
                    return [term, detail]
                  })
                )
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
