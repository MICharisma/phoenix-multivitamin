# Ecto queries and contexts · 13 · Doha composed desk
#
# Teaches:
# - Capstone: composable context functions as the only Repo door
# - Filters pipe through private with_* query builders

defmodule PhoenixMultivitaminWeb.DohaComposedDeskLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.DohaComposedDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Doha composed desk", "Fatima", "Airbus A350-1000")
     |> assign(:filters, %{airline: "Qatar Airways", status: "boarding", min_cargo_kg: 500})
     |> load_legs()}
  end

  @impl true
  def handle_event("compose_filters", params, socket) do
    min_cargo =
      case Integer.parse(Map.get(params, "min_cargo_kg", "")) do
        {value, _} -> value
        :error -> nil
      end

    filters = %{
      airline: Map.get(params, "airline", ""),
      status: Map.get(params, "status", ""),
      min_cargo_kg: min_cargo
    }

    {:noreply,
     socket
     |> assign(:filters, filters)
     |> load_legs()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto queries and contexts · 13 · Doha composed desk
      </p>

      <h1>Doha composed desk</h1>
      <p class="lede">
        Clerk {@clerk} composes {@craft} leg filters through private context
        functions; the LiveView never builds a query.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="leg-count">{@leg_count}</p>

      <form id="compose-form" phx-change="compose_filters">
        <label>
          Airline
          <input
            id="airline-input"
            type="text"
            name="airline"
            value={Map.get(@filters, :airline, "")}
          />
        </label>
        <label>
          Status
          <input
            id="status-input"
            type="text"
            name="status"
            value={Map.get(@filters, :status, "")}
          />
        </label>
        <label>
          Min cargo kg
          <input
            id="min-cargo-input"
            type="number"
            name="min_cargo_kg"
            value={Map.get(@filters, :min_cargo_kg) || ""}
          />
        </label>
      </form>

      <ul id="composed-legs">
        <li :for={leg <- @legs} id={"leg-#{leg.id}"}>
          {leg.destination} · {leg.airline} · {leg.status} · {leg.cargo_kg} kg
        </li>
      </ul>
    </Layouts.app>
    """
  end

  defp load_legs(socket) do
    legs = DohaComposedDesk.list_legs(socket.assigns.filters)

    socket
    |> assign(:legs, legs)
    |> assign(:leg_count, length(legs))
  end
end
