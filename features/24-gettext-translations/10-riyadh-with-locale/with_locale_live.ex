# Gettext translations · 10 · Riyadh with_locale
#
# Teaches:
# - Gettext.with_locale/3 runs a function under a temporary locale
# - The process locale is restored after the function returns
# - Nested with_locale keeps an English brief inside an Arabic desk

defmodule PhoenixMultivitaminWeb.RiyadhWithLocaleLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.RiyadhGettext

  @backend PhoenixMultivitaminWeb.RiyadhGettext

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(@backend, "ar")

    {:ok,
     socket
     |> assign_scenario("Riyadh with_locale", "Fahad", "787-9")
     |> assign(:page_title, "Riyadh with_locale")
     |> assign(:station, "King Khalid International")
     |> assign(:airline, "Saudia")
     |> assign(:outer_locale, Gettext.get_locale(@backend))
     |> assign(:arabic_line, nil)
     |> assign(:english_brief, nil)
     |> assign(:restored_locale, nil)
     |> assign(:nested_pair, nil)}
  end

  @impl true
  def handle_event("paint_desk", _params, socket) do
    arabic = gettext("Hold short of taxiway Bravo")

    english =
      Gettext.with_locale(@backend, "en", fn ->
        gettext("Hold short of taxiway Bravo")
      end)

    restored = Gettext.get_locale(@backend)

    {:noreply,
     socket
     |> assign(:arabic_line, arabic)
     |> assign(:english_brief, english)
     |> assign(:restored_locale, restored)}
  end

  def handle_event("nested_brief", _params, socket) do
    pair =
      Gettext.with_locale(@backend, "ar", fn ->
        arabic = gettext("Cleared to land runway 33L")

        english =
          Gettext.with_locale(@backend, "en", fn ->
            gettext("Cleared to land runway 33L")
          end)

        {arabic, english, Gettext.get_locale(@backend)}
      end)

    {:noreply, assign(socket, :nested_pair, pair)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 10 · Riyadh with_locale
      </p>

      <h1>Riyadh with_locale</h1>
      <p class="lede">
        Clerk {@clerk} keeps the Saudia desk in Arabic at {@station}, then
        borrows English for a brief with <code>Gettext.with_locale/3</code>
        without leaving the process on English.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="outer-locale">{@outer_locale}</p>

      <button id="paint-desk" type="button" phx-click="paint_desk">
        Paint desk
      </button>
      <button id="nested-brief" type="button" phx-click="nested_brief">
        Nested brief
      </button>

      <p :if={@arabic_line} id="arabic-line">{@arabic_line}</p>
      <p :if={@english_brief} id="english-brief">{@english_brief}</p>
      <p :if={@restored_locale} id="restored-locale">{@restored_locale}</p>

      <%= if @nested_pair do %>
        <% {arabic, english, locale_after} = @nested_pair %>
        <p id="nested-arabic">{arabic}</p>
        <p id="nested-english">{english}</p>
        <p id="nested-locale">{locale_after}</p>
      <% end %>
    </Layouts.app>
    """
  end
end
