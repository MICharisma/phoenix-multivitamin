# Gettext translations · 01 · Reykjavík hold-short
#
# Teaches:
# - gettext/1 marks a compile-time msgid on a button the clerk presses
# - use Gettext with an example-local backend so translations stay scenario-local
# - The translated string is an assign, not a concatenated English phrase

defmodule PhoenixMultivitaminWeb.ReykjavikHoldShortLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.ReykjavikGettext

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.ReykjavikGettext, "is")

    {:ok,
     socket
     |> assign_scenario("Reykjavík hold-short", "Sigríður", "Dash 8-200")
     |> assign(:page_title, "Reykjavík hold-short")
     |> assign(:station, "Reykjavík Domestic")
     |> assign(:airline, "Air Iceland Connect")
     |> assign(:hold_line, nil)
     |> assign(:locale, Gettext.get_locale(PhoenixMultivitaminWeb.ReykjavikGettext))}
  end

  @impl true
  def handle_event("paint_hold", _params, socket) do
    {:noreply, assign(socket, :hold_line, gettext("Hold short of runway 13"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 01 · Reykjavík hold-short
      </p>

      <h1>Reykjavík hold-short</h1>
      <p class="lede">
        Clerk {@clerk} paints the hold-short line for the {@craft} on {@airline} at {@station}. The button label is a
        <code>gettext/1</code>
        msgid, resolved against the Icelandic backend for this scenario.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="locale">Locale {@locale}</p>

      <button id="paint-hold" type="button" phx-click="paint_hold">
        {gettext("Paint hold-short")}
      </button>

      <p :if={@hold_line} id="hold-line">{@hold_line}</p>
    </Layouts.app>
    """
  end
end
