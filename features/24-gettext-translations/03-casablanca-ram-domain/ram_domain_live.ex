# Gettext translations · 03 · Casablanca RAM domain
#
# Teaches:
# - dgettext/2 resolves a msgid inside a named domain, not default
# - Gate copy lives in the "gates" domain; ramp copy stays in default
# - with/1 threads a fallible gate lookup into the translated line

defmodule PhoenixMultivitaminWeb.CasablancaRamDomainLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.CasablancaGettext

  @gates %{
    "A12" => :open,
    "B04" => :closed,
    "C07" => :hold
  }

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.CasablancaGettext, "fr")

    {:ok,
     socket
     |> assign_scenario("Casablanca RAM domain", "Yasmine", "ATR 72")
     |> assign(:page_title, "Casablanca RAM domain")
     |> assign(:station, "Mohammed V")
     |> assign(:airline, "Royal Air Maroc")
     |> assign(:gate_line, nil)
     |> assign(:ramp_line, gettext("Ramp clear for pushback"))
     |> assign(:error, nil)}
  end

  @impl true
  def handle_event("announce_gate", %{"gate" => gate}, socket) do
    socket =
      with {:ok, state} <- fetch_gate(gate) do
        line =
          case state do
            :open -> dgettext("gates", "Gate open for boarding")
            :closed -> dgettext("gates", "Gate closed")
            :hold -> dgettext("gates", "Gate on hold")
          end

        socket
        |> assign(:gate_line, line)
        |> assign(:error, nil)
      else
        :error ->
          assign(socket, :error, dgettext("gates", "Unknown gate"))
      end

    {:noreply, socket}
  end

  defp fetch_gate(gate) do
    case Map.fetch(@gates, gate) do
      {:ok, state} -> {:ok, state}
      :error -> :error
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 03 · Casablanca RAM domain
      </p>

      <h1>Casablanca RAM domain</h1>
      <p class="lede">
        Clerk {@clerk} posts Royal Air Maroc gate states at {@station}.
        Gate phrases live in the <code>gates</code>
        domain via <code>dgettext/2</code>; the ramp line stays in default.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="ramp-line">{@ramp_line}</p>

      <div id="gate-buttons">
        <button
          :for={gate <- ["A12", "B04", "C07", "Z99"]}
          id={"gate-#{gate}"}
          type="button"
          phx-click="announce_gate"
          phx-value-gate={gate}
        >
          {gate}
        </button>
      </div>

      <p :if={@gate_line} id="gate-line">{@gate_line}</p>
      <p :if={@error} id="gate-error">{@error}</p>
    </Layouts.app>
    """
  end
end
