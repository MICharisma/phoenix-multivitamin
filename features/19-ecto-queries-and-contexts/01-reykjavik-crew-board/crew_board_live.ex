# Ecto queries and contexts · 01 · Reykjavik crew board
#
# Teaches:
# - Keyword from/where/order_by via a context door
# - The web layer lists posted crew without composing a query

defmodule PhoenixMultivitaminWeb.ReykjavikCrewBoardLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.ReykjavikCrewBoard

  @impl true
  def mount(_params, _session, socket) do
    assignments = ReykjavikCrewBoard.list_posted_assignments()

    {:ok,
     socket
     |> assign_scenario("Reykjavik crew board", "Sigríður", "Boeing 757-200")
     |> assign(:assignments, assignments)
     |> assign(:posted_count, length(assignments))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 01 · Reykjavik crew board
      </p>

      <h1>Reykjavik crew board</h1>
      <p class="lede">
        Clerk {@clerk} opens the posted {@craft} crew board through a keyword query
        that never leaves the context.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="posted-count">{@posted_count}</p>

      <ul id="posted-assignments">
        <li :for={assignment <- @assignments} id={"assignment-#{assignment.id}"}>
          <span class="role">{assignment.role}</span> · {assignment.clerk}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
