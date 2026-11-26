# Gettext translations · 06 · São Paulo put_locale
#
# Teaches:
# - Gettext.put_locale/2 in handle_params switches the process locale from a query
# - put_locale is process-dictionary state; each LiveView mount process needs it
# - Guards reject unsupported locale atoms before the board paints

defmodule PhoenixMultivitaminWeb.SaoPauloPutLocaleLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.SaoPauloGettext

  @backend PhoenixMultivitaminWeb.SaoPauloGettext
  @supported ~w(pt en)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("São Paulo put_locale", "Márcia", "E195-E2")
     |> assign(:page_title, "São Paulo put_locale")
     |> assign(:station, "Congonhas")
     |> assign(:airline, "GOL")
     |> assign(:locale, "pt")
     |> assign(:pushback_line, nil)
     |> assign(:rejected_locale, nil)}
  end

  @impl true
  def handle_params(%{"locale" => locale}, _uri, socket) when locale in @supported do
    Gettext.put_locale(@backend, locale)

    {:noreply,
     socket
     |> assign(:locale, locale)
     |> assign(:rejected_locale, nil)
     |> assign(:pushback_line, gettext("Cleared for pushback at Congonhas"))}
  end

  def handle_params(%{"locale" => locale}, _uri, socket) do
    Gettext.put_locale(@backend, "pt")

    {:noreply,
     socket
     |> assign(:locale, "pt")
     |> assign(:rejected_locale, locale)
     |> assign(:pushback_line, gettext("Cleared for pushback at Congonhas"))}
  end

  def handle_params(_params, _uri, socket) do
    Gettext.put_locale(@backend, "pt")

    {:noreply,
     socket
     |> assign(:locale, "pt")
     |> assign(:pushback_line, gettext("Cleared for pushback at Congonhas"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 06 · São Paulo put_locale
      </p>

      <h1>São Paulo put_locale</h1>
      <p class="lede">
        Clerk {@clerk} sets the Congonhas pushback line for GOL. The locale
        query drives <code>Gettext.put_locale/2</code> in <code>handle_params/3</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="locale">{@locale}</p>
      <p :if={@rejected_locale} id="rejected-locale">{@rejected_locale}</p>
      <p id="pushback-line">{@pushback_line}</p>

      <.link
        id="locale-pt"
        patch={~p"/features/24-gettext-translations/06-sao-paulo-put-locale?locale=pt"}
      >
        Português
      </.link>
      <.link
        id="locale-en"
        patch={~p"/features/24-gettext-translations/06-sao-paulo-put-locale?locale=en"}
      >
        English
      </.link>
    </Layouts.app>
    """
  end
end
