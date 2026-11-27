# Ecto queries and contexts · 05 · Tokyo join preload
#
# Teaches:
# - Join-preload loads the airline in the same query
# - Template reads crew.tokyo_airline.name without a second fetch

defmodule PhoenixMultivitaminWeb.TokyoJoinPreloadLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.TokyoCrewDesk

  @impl true
  def mount(_params, _session, socket) do
    crews = TokyoCrewDesk.list_crews_with_airline()

    {:ok,
     socket
     |> assign_scenario("Tokyo join preload", "Haruto", "Boeing 787-9")
     |> assign(:crews, crews)
     |> assign(:crew_count, length(crews))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto queries and contexts · 05 · Tokyo join preload
      </p>

      <h1>Tokyo join preload</h1>
      <p class="lede">
        Clerk {@clerk} join-preloads the airline on each {@craft} crew row
        in one query.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="crew-count">{@crew_count}</p>

      <ul id="tokyo-crews">
        <li :for={crew <- @crews} id={"crew-#{crew.id}"}>
          {crew.role} · {crew.clerk} · {crew.tokyo_airline.name} ({crew.tokyo_airline.iata})
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
