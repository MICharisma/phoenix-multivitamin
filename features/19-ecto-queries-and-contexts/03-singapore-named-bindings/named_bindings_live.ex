# Ecto queries and contexts · 03 · Singapore named bindings
#
# Teaches:
# - Named bindings with as:/as(:name) in joins and where
# - select maps keyed from named bindings

defmodule PhoenixMultivitaminWeb.SingaporeNamedBindingsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.SingaporeHubDesk

  @impl true
  def mount(_params, _session, socket) do
    flights = SingaporeHubDesk.list_flights_for_iata("SQ")

    {:ok,
     socket
     |> assign_scenario("Singapore named bindings", "Mei Ling", "Airbus A350-900")
     |> assign(:flights, flights)
     |> assign(:flight_count, length(flights))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 03 · Singapore named bindings
      </p>

      <h1>Singapore named bindings</h1>
      <p class="lede">
        Clerk {@clerk} filters {@craft} legs by named airline binding IATA,
        not join position.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="flight-count">{@flight_count}</p>

      <ul id="named-flights">
        <li :for={flight <- @flights} id={"flight-#{flight.flight_number}"}>
          {flight.flight_number} · {flight.destination} · gate {flight.gate} · {flight.airline}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
