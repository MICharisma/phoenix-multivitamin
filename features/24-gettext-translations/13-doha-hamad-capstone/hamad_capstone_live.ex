# Gettext translations · 13 · Doha Hamad capstone
#
# Teaches:
# - Capstone catalog page links onto the locale-plugged desk

defmodule PhoenixMultivitaminWeb.DohaHamadCapstoneLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Doha Hamad capstone", "Noor", "A350-1000")
     |> assign(:page_title, "Doha Hamad capstone")
     |> assign(:station, "Hamad International")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 13 · Doha Hamad capstone
      </p>

      <h1>Doha Hamad capstone</h1>
      <p class="lede">
        Clerk {@clerk} opens the Hamad load-sheet desk: locale from
        params/session/Accept-Language, Arabic plurals, a gates domain line,
        and Ecto errors through the errors domain.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.link
        id="open-desk"
        href={~p"/features/24-gettext-translations/13-doha-hamad-capstone/desk?locale=ar&bags=3"}
      >
        Open Arabic desk
      </.link>
      <.link
        id="open-blank-sheet"
        href={~p"/features/24-gettext-translations/13-doha-hamad-capstone/desk?locale=ar"}
      >
        Open blank sheet
      </.link>
    </Layouts.app>
    """
  end
end
