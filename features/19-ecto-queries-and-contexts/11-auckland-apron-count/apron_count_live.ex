# Ecto queries and contexts · 11 · Auckland apron count
#
# Teaches:
# - Repo.aggregate counts without loading stand structs
# - Occupied and free counts from filtered queries

defmodule PhoenixMultivitaminWeb.AucklandApronCountLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.AucklandApronDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Auckland apron count", "Mere", "ATR 72-500")
     |> assign(:occupied_count, AucklandApronDesk.occupied_stand_count())
     |> assign(:free_count, AucklandApronDesk.free_stand_count())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 11 · Auckland apron count
      </p>

      <h1>Auckland apron count</h1>
      <p class="lede">
        Clerk {@clerk} counts occupied and free {@craft} stands with
        Repo.aggregate, without loading the rows.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="occupied-count">{@occupied_count}</p>
      <p id="free-count">{@free_count}</p>
    </Layouts.app>
    """
  end
end
