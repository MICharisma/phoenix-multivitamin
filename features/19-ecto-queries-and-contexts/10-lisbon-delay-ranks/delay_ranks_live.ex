# Ecto queries and contexts · 10 · Lisbon delay ranks
#
# Teaches:
# - Window row_number partitioned by airline
# - Ranked delays stay as rows, not groups

defmodule PhoenixMultivitaminWeb.LisbonDelayRanksLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.LisbonDelayRanks

  @impl true
  def mount(_params, _session, socket) do
    delays = LisbonDelayRanks.ranked_delays()

    {:ok,
     socket
     |> assign_scenario("Lisbon delay ranks", "Inês", "Embraer E190")
     |> assign(:delays, delays)
     |> assign(:delay_count, length(delays))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto queries and contexts · 10 · Lisbon delay ranks
      </p>

      <h1>Lisbon delay ranks</h1>
      <p class="lede">
        Clerk {@clerk} ranks {@craft} delays per airline with a window
        row_number, without collapsing the rows.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="delay-count">{@delay_count}</p>

      <ul id="delay-ranks">
        <li :for={delay <- @delays} id={"delay-#{delay.id}"}>
          #{delay.rank} · {delay.airline} · {delay.minutes} min · {delay.craft}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
