# Channels · 06 · Figari Bonifacio isolation
#
# Teaches:
# - One handle_in/3 can reply to the sender, push/3 to the sender alone, and broadcast_from!/3 to the rest.
# - broadcast!/3 includes the sender; broadcast_from!/3 skips the sending channel process.
# - The socket implements connect/2 because it never reads connect_info.
# - The JS client delegates clicks from one listener and detaches a handler with channel.off(event, ref).

defmodule PhoenixMultivitaminWeb.FigariBonifacioIsolationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario(
       "Figari Bonifacio isolation",
       "Paul-Antoine Santoni",
       "Air Corsica A320neo F-HZFM"
     )
     |> assign(stands: ~w(1 2 3 4 5))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Channels · 06 · Figari Bonifacio isolation
      </p>

      <h1>Figari Bonifacio isolation</h1>
      <p class="lede">
        Marshal {@clerk} isolates a stand at Figari–Sud Corse after a spill under the {@craft}.
        He gets the checklist; the fuel truck and fire tender get the notice.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <section
        id="bonifacio-isolation"
        class="scenario"
        phx-hook=".BonifacioIsolation"
        phx-update="ignore"
        data-socket-path="/features/17-channels/06-figari-bonifacio-isolation/socket"
      >
        <label>
          Unit
          <select data-unit>
            <option value="marshal">Marshal</option>
            <option value="fuel_truck">Fuel truck</option>
            <option value="fire_tender">Fire tender</option>
          </select>
        </label>
        <label><input type="checkbox" data-mute /> Mute notices from other units</label>
        <div class="watch-actions">
          <span :for={stand <- @stands}>
            <button type="button" data-isolate={stand} data-hazard="fuel_spill">Isolate {stand}</button>
            <button type="button" data-lift={stand}>Lift {stand}</button>
          </span>
        </div>
        <ol class="watch-log" data-checklist></ol>
        <p data-isolation-lamp role="status">Pick a unit.</p>
      </section>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".BonifacioIsolation">
        import {Socket} from "phoenix"

        export default {
          mounted() {
            this.lamp = this.el.querySelector("[data-isolation-lamp]")
            const unitPicker = this.el.querySelector("[data-unit]")
            unitPicker.addEventListener("change", () => this.reportAs(unitPicker.value))
            this.reportAs(unitPicker.value)

            this.el.querySelector("[data-mute]").addEventListener("change", ({target: {checked}}) => {
              if (checked) {
                this.apron.off("stand_isolated", this.noticeRef)
              } else {
                this.noticeRef = this.apron.on("stand_isolated", notice => this.notice(notice))
              }
            })

            this.el.addEventListener("click", ({target}) => {
              const button = target.closest("[data-isolate], [data-lift]")
              if (!button) return
              const {isolate, lift, hazard} = button.dataset
              if (isolate) {
                this.apron.push("isolate_stand", {stand: isolate, hazard})
                  .receive("ok", ({isolation_ref}) => this.lamp.textContent = `Isolation ${isolation_ref} logged.`)
                  .receive("error", ({reason}) => this.lamp.textContent = reason)
              } else {
                this.apron.push("lift_isolation", {stand: lift})
              }
            })
          },
          reportAs(unit) {
            this.socket?.disconnect()
            this.socket = new Socket(this.el.dataset.socketPath, {params: {unit}})
            this.socket.connect()
            this.apron = this.socket.channel("figari:apron")
            this.noticeRef = this.apron.on("stand_isolated", notice => this.notice(notice))
            this.apron.on("isolation_checklist", ({stand, steps}) => {
              this.el.querySelector("[data-checklist]").replaceChildren(
                ...steps.map(step => Object.assign(document.createElement("li"), {textContent: `Stand ${stand}: ${step}`}))
              )
            })
            this.apron.on("isolation_lifted", ({stand, by}) => this.lamp.textContent = `Stand ${stand} reopened by ${by}.`)
            this.apron.join().receive("ok", () => this.lamp.textContent = `On the apron as ${unit.replace("_", " ")}.`)
          },
          notice({stand, hazard, by}) {
            this.lamp.textContent = `Stand ${stand} isolated by ${by}: ${hazard.replace("_", " ")}.`
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
