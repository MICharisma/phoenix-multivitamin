# Ecto queries and contexts · 04 · Johannesburg bay filters
#
# Teaches:
# - dynamic/2 optional filters from event params
# - Empty filters keep dynamic(true)

defmodule PhoenixMultivitaminWeb.JohannesburgBayFiltersLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.JohannesburgBayDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Johannesburg bay filters", "Thabo", "Airbus A320neo")
     |> assign(:filters, %{})
     |> load_cards()}
  end

  @impl true
  def handle_event("filter_bays", %{"bay" => bay, "status" => status}, socket) do
    filters =
      %{}
      |> maybe_put(:bay, bay)
      |> maybe_put(:status, status)

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> load_cards()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 04 · Johannesburg bay filters
      </p>

      <h1>Johannesburg bay filters</h1>
      <p class="lede">
        Clerk {@clerk} builds optional {@craft} bay filters with dynamic/2.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="card-count">{@card_count}</p>

      <form id="bay-filter-form" phx-change="filter_bays">
        <label>
          Bay <input id="bay-input" type="text" name="bay" value={Map.get(@filters, :bay, "")} />
        </label>
        <label>
          Status
          <input id="status-input" type="text" name="status" value={Map.get(@filters, :status, "")} />
        </label>
      </form>

      <ul id="bay-cards">
        <li :for={card <- @cards} id={"bay-card-#{card.id}"}>
          {card.bay} · {card.status} · defects {card.open_defects}
        </li>
      </ul>
    </Layouts.app>
    """
  end

  defp load_cards(socket) do
    cards = JohannesburgBayDesk.list_bay_cards(socket.assigns.filters)

    socket
    |> assign(:cards, cards)
    |> assign(:card_count, length(cards))
  end

  defp maybe_put(map, _key, ""), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
