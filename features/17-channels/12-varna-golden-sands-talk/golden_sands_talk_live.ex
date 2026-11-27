# Channels · 12 · Varna Golden Sands talk
#
# Teaches:
# - handle_in/3 returns :noreply while a Task.async/3 works; socket_ref/1 keeps the reply path.
# - handle_info/2 matches the task result and calls reply/2 with {:ok, map} or {:error, map}.
# - ChannelCase imports Phoenix.ChannelTest and sets @endpoint for connect/join/assert_reply.
# - The JS client sets a push timeout shorter than the desk latency so a slow CFMU answer times out.

defmodule PhoenixMultivitaminWeb.VarnaGoldenSandsTalkLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @departures [
    %{flight: "W6 2471", eobt: "09:40", destination: "EGKK", label: "Wizz Air to Gatwick"},
    %{flight: "FB 981", eobt: "11:15", destination: "ESSA", label: "Bulgaria Air to Stockholm"},
    %{
      flight: "QS 1482",
      eobt: "14:05",
      destination: "LKPR",
      label: "Smartwings to Prague (no FPL)"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Varna Golden Sands talk",
       "Desislava Petrova",
       "Wizz Air A321neo HA-LZA"
     )
     |> assign(departures: @departures, network_latency_ms: 1_200)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 12 · Varna Golden Sands talk
      </p>

      <h1>Varna Golden Sands talk</h1>
      <p class="lede">
        Slot coordinator {@clerk} at Varna asks CFMU for CTOTs while the {@craft} boards for
        the Golden Sands charter season. The desk answers after a network delay.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="golden-sands-talk"
        class="scenario"
        phx-hook=".GoldenSandsTalk"
        phx-update="ignore"
        data-socket-path="/features/17-channels/12-varna-golden-sands-talk/socket"
        data-handler={@clerk}
        data-network-latency-ms={@network_latency_ms}
        data-push-timeout-ms="500"
      >
        <ul class="watch-log">
          <li :for={departure <- @departures}>
            <button
              type="button"
              data-request-ctot
              data-flight={departure.flight}
              data-eobt={departure.eobt}
              data-destination={departure.destination}
            >
              Request CTOT for {departure.label}
            </button>
            <span data-slot-state={departure.flight}>waiting</span>
          </li>
        </ul>
        <p data-slot-lamp role="status">Opening the slot desk.</p>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".GoldenSandsTalk">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            const {socketPath, handler, networkLatencyMs, pushTimeoutMs} = this.el.dataset
            this.lamp = this.el.querySelector("[data-slot-lamp]")
            this.socket = new Socket(socketPath, {params: {handler}, timeout: Number(pushTimeoutMs)})
            this.socket.connect()
            this.slots = this.socket.channel("golden_sands:slots", {
              network_latency_ms: Number(networkLatencyMs)
            })
            this.slots.join().receive("ok", ({handler, network_latency_ms}) => {
              this.lamp.textContent =
                `${handler}: CFMU latency ${network_latency_ms} ms, push timeout ${pushTimeoutMs} ms.`
            })

            this.el.addEventListener("click", ({target}) => {
              const button = target.closest("[data-request-ctot]")
              if (!button) return
              const {flight, eobt, destination} = button.dataset
              const state = this.el.querySelector(`[data-slot-state="${CSS.escape(flight)}"]`)
              state.textContent = "requesting…"
              this.slots.push("request_ctot", {flight, eobt, destination}, Number(pushTimeoutMs))
                .receive("ok", ({ctot, regulation, delay_min}) => {
                  state.textContent = regulation
                    ? `CTOT ${ctot} (${regulation}, +${delay_min} min)`
                    : `CTOT ${ctot}, no regulation`
                })
                .receive("error", ({reason}) => { state.textContent = reason })
                .receive("timeout", () => {
                  state.textContent = "CFMU timed out on the client; the desk may still answer."
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
