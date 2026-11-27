# Channels · 04 · Pau Pyrenees callback
#
# Teaches:
# - broadcast!/3 from handle_in/3 reaches every socket on the topic, the sender included.
# - A function head matching %{assigns: %{role: "dispatcher"}} gates who may page the crew.
# - Map.new/2 with a capture shapes the callout; Map.fetch/2 with case refuses an unknown valley.
# - The JS client renders channel.on events from a <template> with Intl.DateTimeFormat.

defmodule PhoenixMultivitaminWeb.PauPyreneesCallbackLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @crew [
    {"dispatcher", "CODIS 64 Lucie Etcheverry"},
    {"pilot", "Dragon 64 Pilot Mathieu Larrouy"},
    {"winch_operator", "Dragon 64 Winch Inès Bordenave"},
    {"doctor", "SAMU 64 Dr Pierre Casenave"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Pau Pyrenees callback",
       "Lucie Etcheverry",
       "Sécurité Civile EC145 Dragon 64"
     )
     |> assign(crew: @crew)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 04 · Pau Pyrenees callback
      </p>

      <h1>Pau Pyrenees callback</h1>
      <p class="lede">
        Dispatcher {@clerk} pages the {@craft} crew from Pau–Pyrénées. Open this page in a
        second tab as the winch operator to watch the callout arrive.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="pyrenees-callback"
        class="scenario"
        phx-hook=".PyreneesCallback"
        phx-update="ignore"
        data-socket-path="/features/17-channels/04-pau-pyrenees-callback/socket"
      >
        <label>
          Sign in as
          <select data-crew-member>
            <option :for={{role, callsign} <- @crew} value={role} data-callsign={callsign}>
              {callsign}
            </option>
          </select>
        </label>
        <form data-page-form>
          <select name="valley">
            <option value="ossau">Vallée d'Ossau</option>
            <option value="aspe">Vallée d'Aspe</option>
            <option value="baretous">Vallée de Barétous</option>
          </select>
          <input name="casualty" value="Hiker, suspected ankle fracture" />
          <input name="altitude_m" type="number" value="1870" />
          <button type="submit">Page the crew</button>
        </form>
        <p data-callback-lamp role="status">Choose who you are.</p>
        <ul class="watch-log" data-callouts></ul>
        <template data-callout-row>
          <li>
            <strong data-valley></strong> <span data-detail></span>
            <button type="button" data-ack>Ready</button>
          </li>
        </template>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".PyreneesCallback">
        import {Socket} from "phoenix"

        const pagedAt = new Intl.DateTimeFormat("fr-FR", {timeStyle: "short", timeZone: "Europe/Paris"})

        export default {
          mounted() {
            this.lamp = this.el.querySelector("[data-callback-lamp]")
            const picker = this.el.querySelector("[data-crew-member]")
            picker.addEventListener("change", () => this.signIn(picker.selectedOptions[0]))
            this.signIn(picker.selectedOptions[0])

            this.el.querySelector("[data-page-form]").addEventListener("submit", event => {
              event.preventDefault()
              const form = Object.fromEntries(new FormData(event.target))
              this.channel.push("page_crew", {...form, altitude_m: Number(form.altitude_m)})
                .receive("ok", ({eta_min}) => this.lamp.textContent = `Crew paged, ${eta_min} min to the landing zone.`)
                .receive("error", ({reason}) => this.lamp.textContent = reason)
            })
          },
          signIn({value: role, dataset: {callsign}}) {
            this.socket?.disconnect()
            this.socket = new Socket(this.el.dataset.socketPath, {params: {role, callsign}})
            this.socket.connect()
            this.channel = this.socket.channel("pyrenees:dragon64")
            this.channel.on("callout", callout => this.renderCallout(callout))
            this.channel.on("crew_ready", ({callsign}) => this.lamp.textContent = `${callsign} is ready.`)
            this.channel.join().receive("ok", () => this.lamp.textContent = `Signed in as ${callsign}.`)
          },
          renderCallout({name, lz, casualty, altitude_m, paged_by, paged_at}) {
            const row = this.el.querySelector("[data-callout-row]").content.cloneNode(true)
            row.querySelector("[data-valley]").textContent = `${name} · ${lz}`
            row.querySelector("[data-detail]").textContent =
              `${casualty} at ${altitude_m} m, paged by ${paged_by} at ${pagedAt.format(new Date(paged_at))}`
            row.querySelector("[data-ack]").addEventListener("click", () => this.channel.push("acknowledge", {}), {once: true})
            this.el.querySelector("[data-callouts]").prepend(row)
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
