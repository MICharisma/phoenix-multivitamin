# Ecto queries and contexts · 07 · Helsinki overdue cards
#
# Teaches:
# - exists + subquery + parent_as for correlated filters
# - Only aircraft that still carry an overdue card appear

defmodule PhoenixMultivitaminWeb.HelsinkiOverdueCardsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.HelsinkiOverdueDesk

  @impl true
  def mount(_params, _session, socket) do
    aircraft = HelsinkiOverdueDesk.list_aircraft_with_overdue_cards()

    {:ok,
     socket
     |> assign_scenario("Helsinki overdue cards", "Aino", "ATR 72-600")
     |> assign(:aircraft, aircraft)
     |> assign(:aircraft_count, length(aircraft))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 07 · Helsinki overdue cards
      </p>

      <h1>Helsinki overdue cards</h1>
      <p class="lede">
        Clerk {@clerk} keeps {@craft} tails that still have an overdue work card,
        via a correlated exists subquery.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="aircraft-count">{@aircraft_count}</p>

      <ul id="overdue-aircraft">
        <li :for={tail <- @aircraft} id={"aircraft-#{tail.id}"}>
          {tail.registration} · {tail.craft}
          <span class="overdue-titles">
            {Enum.map_join(Enum.filter(tail.work_cards, & &1.overdue), ", ", & &1.title)}
          </span>
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
