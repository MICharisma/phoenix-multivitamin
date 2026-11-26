# Gettext translations · 04 · Dubai Emirates context
#
# Teaches:
# - pgettext/2 disambiguates the same English word with a msgctxt
# - "open" as a gate state is not "open" as a stand state in Arabic
# - cond picks the context atom before the macro runs

defmodule PhoenixMultivitaminWeb.DubaiEmiratesContextLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.DubaiGettext

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.DubaiGettext, "ar")

    {:ok,
     socket
     |> assign_scenario("Dubai Emirates context", "Layla", "A380-800")
     |> assign(:page_title, "Dubai Emirates context")
     |> assign(:station, "Dubai International")
     |> assign(:airline, "Emirates")
     |> assign(:gate_word, nil)
     |> assign(:stand_word, nil)}
  end

  @impl true
  def handle_event("paint", %{"surface" => surface}, socket) do
    word =
      cond do
        surface == "gate" -> pgettext("gate state", "open")
        surface == "stand" -> pgettext("stand state", "open")
        true -> pgettext("unknown surface", "open")
      end

    socket =
      case surface do
        "gate" -> assign(socket, :gate_word, word)
        "stand" -> assign(socket, :stand_word, word)
        _ -> socket
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 04 · Dubai Emirates context
      </p>

      <h1>Dubai Emirates context</h1>
      <p class="lede">
        Clerk {@clerk} paints Emirates A380 states at {@station}. The English
        word <em>open</em> needs a <code>pgettext/2</code> context before Arabic
        can choose the right form for a gate versus a stand.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <button id="paint-gate" type="button" phx-click="paint" phx-value-surface="gate">
        Gate
      </button>
      <button id="paint-stand" type="button" phx-click="paint" phx-value-surface="stand">
        Stand
      </button>

      <p :if={@gate_word} id="gate-word">{@gate_word}</p>
      <p :if={@stand_word} id="stand-word">{@stand_word}</p>
    </Layouts.app>
    """
  end
end
