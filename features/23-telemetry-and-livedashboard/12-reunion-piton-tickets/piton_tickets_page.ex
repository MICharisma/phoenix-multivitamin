# Telemetry and LiveDashboard · 12 · Réunion Piton tickets
#
# Teaches:
# - A custom LiveDashboard page implements Phoenix.LiveDashboard.PageBuilder
# - menu_link/2 can enable, disable, or skip the page from session + capabilities

defmodule PhoenixMultivitaminWeb.ReunionPitonTicketsPage do
  @moduledoc false
  use Phoenix.LiveDashboard.PageBuilder

  @menu_text "Piton tickets"

  @impl true
  def init(opts) when is_list(opts) do
    tickets = Keyword.get(opts, :tickets, default_tickets())

    {:ok, %{tickets: tickets, volcano: "Piton de la Fournaise"}}
  end

  @impl true
  def menu_link(%{tickets: []}, _capabilities) do
    {:disabled, @menu_text}
  end

  def menu_link(%{tickets: tickets}, _capabilities) when is_list(tickets) do
    {:ok, @menu_text}
  end

  @impl true
  def mount(_params, session, socket) do
    tickets = Map.fetch!(session, :tickets)
    volcano = Map.fetch!(session, :volcano)

    {:ok,
     assign(socket,
       tickets: tickets,
       volcano: volcano,
       open_count: Enum.count(tickets, &(&1.status == :open))
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.row>
      <:col>
        <.card title="Réunion volcanic holds">
          <p id="piton-volcano">{@volcano}</p>
          <p id="piton-open-count">{@open_count} open tickets</p>
        </.card>
        <.card :for={ticket <- @tickets} title={ticket.flight}>
          <p id={"ticket-#{ticket.flight}"}>
            {ticket.reason} · {ticket.status}
          </p>
        </.card>
      </:col>
    </.row>
    """
  end

  def default_tickets do
    [
      %{flight: "UU974", reason: "Ash drift over Roland Garros", status: :open},
      %{flight: "AF646", reason: "Piton plume clears midmorning", status: :held},
      %{flight: "SS710", reason: "St-Pierre diversion released", status: :cleared}
    ]
  end

  def menu_label(session, capabilities) do
    menu_link(session, capabilities)
  end
end
