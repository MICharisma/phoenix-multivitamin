# Gettext translations · 05 · Lyon Accept-Language
#
# Teaches:
# - The catalog page links onto a controller that runs the locale plug

defmodule PhoenixMultivitaminWeb.LyonAcceptLanguageLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Lyon Accept-Language", "Camille", "A320neo")
     |> assign(:page_title, "Lyon Accept-Language")
     |> assign(:station, "Lyon–Saint-Exupéry")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 05 · Lyon Accept-Language
      </p>

      <h1>Lyon Accept-Language</h1>
      <p class="lede">
        Clerk {@clerk} opens the ATIS desk through a locale plug that reads
        the Accept-Language header before the controller paints the line.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.link
        id="open-atis"
        href={~p"/features/24-gettext-translations/05-lyon-accept-language/atis"}
      >
        Open ATIS desk
      </.link>
    </Layouts.app>
    """
  end
end
