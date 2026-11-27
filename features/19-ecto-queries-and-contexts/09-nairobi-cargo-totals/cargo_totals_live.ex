# Ecto queries and contexts · 09 · Nairobi cargo totals
#
# Teaches:
# - group_by/having totals through the context
# - Only airlines above the kilogram threshold appear

defmodule PhoenixMultivitaminWeb.NairobiCargoTotalsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.NairobiCargoTotals

  @impl true
  def mount(_params, _session, socket) do
    totals = NairobiCargoTotals.airline_totals_above(3000)

    {:ok,
     socket
     |> assign_scenario("Nairobi cargo totals", "Wanjiku", "Boeing 747-400F")
     |> assign(:totals, totals)
     |> assign(:airline_count, length(totals))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 09 · Nairobi cargo totals
      </p>

      <h1>Nairobi cargo totals</h1>
      <p class="lede">
        Clerk {@clerk} groups {@craft} shipments by airline and keeps totals
        that clear three tonnes.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="airline-count">{@airline_count}</p>

      <ul id="cargo-totals">
        <li :for={total <- @totals} id={"total-#{total.airline}"}>
          {total.airline} · {total.total_kg} kg · {total.legs} legs
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
