# Telemetry and LiveDashboard · 12 · Réunion Piton tickets
#
# Teaches:
# - additional_pages wires a PageBuilder module into live_dashboard/2
# - The catalog LiveView shows the same ticket board the dashboard page renders

defmodule PhoenixMultivitaminWeb.ReunionPitonTicketsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.ReunionPitonTicketsPage

  @impl true
  def mount(_params, _session, socket) do
    tickets = ReunionPitonTicketsPage.default_tickets()

    {:ok, menu} =
      case ReunionPitonTicketsPage.menu_label(%{tickets: tickets}, %{}) do
        {:ok, text} -> {:ok, text}
        other -> {:ok, inspect(other)}
      end

    disabled =
      case ReunionPitonTicketsPage.menu_label(%{tickets: []}, %{}) do
        {:disabled, text} -> text
        other -> inspect(other)
      end

    {:ok,
     socket
     |> assign_scenario("Réunion Piton tickets", "Gaëlle", "ATR 72-600")
     |> assign(:airport, "Roland Garros")
     |> assign(:tickets, tickets)
     |> assign(:menu_label, menu)
     |> assign(:disabled_label, disabled)
     |> assign(:dashboard_path, "/dev/dashboard/piton_tickets")}
  end

  @impl true
  def handle_event("release_ticket", %{"flight" => flight}, socket) do
    tickets =
      Enum.map(socket.assigns.tickets, fn
        %{flight: ^flight} = ticket -> %{ticket | status: :cleared}
        ticket -> ticket
      end)

    {:noreply, assign(socket, :tickets, tickets)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 12 · Réunion Piton tickets
      </p>

      <h1>Réunion Piton tickets</h1>
      <p class="lede">
        {@clerk} tracks ash holds at {@airport} while Piton de la Fournaise steams.
        A custom LiveDashboard page lists the same tickets under <code>additional_pages</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="scenario">
        <h2>Dashboard menu contract</h2>
        <p id="menu-enabled">Enabled label: {@menu_label}</p>
        <p id="menu-disabled">Empty board disables: {@disabled_label}</p>
        <.link id="open-piton-dashboard" href={@dashboard_path}>
          Open Piton tickets in LiveDashboard
        </.link>
      </div>

      <div id="ticket-board" class="scenario">
        <h2>Hold board</h2>
        <article :for={ticket <- @tickets} id={"board-#{ticket.flight}"}>
          <h3>{ticket.flight}</h3>
          <p>{ticket.reason}</p>
          <p id={"status-#{ticket.flight}"}>{ticket.status}</p>
          <button
            :if={ticket.status != :cleared}
            id={"release-#{ticket.flight}"}
            type="button"
            phx-click="release_ticket"
            phx-value-flight={ticket.flight}
          >
            Release {ticket.flight}
          </button>
        </article>
      </div>
    </Layouts.catalog>
    """
  end
end
