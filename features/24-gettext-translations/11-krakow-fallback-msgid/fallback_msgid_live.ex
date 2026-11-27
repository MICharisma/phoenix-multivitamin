# Gettext translations · 11 · Kraków fallback msgid
#
# Teaches:
# - A missing translation falls back to the msgid itself
# - An empty msgstr is treated as untranslated
# - case splits the translated de-ice line from the untranslated NOTAM line

defmodule PhoenixMultivitaminWeb.KrakowFallbackMsgidLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.KrakowGettext

  @backend PhoenixMultivitaminWeb.KrakowGettext
  @deice_msgid "De-ice pad open"
  @notam_msgid "Snow NOTAM pending review"

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(@backend, "pl")

    deice = gettext("De-ice pad open")
    notam = gettext("Snow NOTAM pending review")

    {:ok,
     socket
     |> assign_scenario("Kraków fallback msgid", "Ola", "Dash 8-400")
     |> assign(:page_title, "Kraków fallback msgid")
     |> assign(:station, "Kraków Balice")
     |> assign(:airline, "LOT Polish Airlines")
     |> assign(:deice_line, deice)
     |> assign(:notam_line, notam)
     |> assign(:deice_fallback?, deice == @deice_msgid)
     |> assign(:notam_fallback?, notam == @notam_msgid)}
  end

  @impl true
  def handle_event("classify", _params, socket) do
    classification =
      case {socket.assigns.deice_fallback?, socket.assigns.notam_fallback?} do
        {false, true} -> "de-ice translated; NOTAM fell back to msgid"
        {true, true} -> "both fell back"
        {false, false} -> "both translated"
        {true, false} -> "de-ice fell back; NOTAM translated"
      end

    {:noreply, assign(socket, :classification, classification)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 11 · Kraków fallback msgid
      </p>

      <h1>Kraków fallback msgid</h1>
      <p class="lede">
        Clerk {@clerk} posts the Balice de-ice pad for LOT. The de-ice line
        has a Polish msgstr; the snow NOTAM msgid has none, so Gettext
        returns the English msgid.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="deice-line" data-fallback={to_string(@deice_fallback?)}>{@deice_line}</p>
      <p id="notam-line" data-fallback={to_string(@notam_fallback?)}>{@notam_line}</p>

      <button id="classify" type="button" phx-click="classify">Classify</button>
      <p :if={assigns[:classification]} id="classification">{@classification}</p>
    </Layouts.app>
    """
  end
end
