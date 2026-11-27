# Ecto queries and contexts · 02 · Dubai cargo holds
#
# Teaches:
# - Pipe-syntax queries composed in the context
# - Sealed holds listed without a keyword from/2

defmodule PhoenixMultivitaminWeb.DubaiCargoHoldsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.DubaiCargoHolds

  @impl true
  def mount(_params, _session, socket) do
    holds = DubaiCargoHolds.list_sealed_holds()

    {:ok,
     socket
     |> assign_scenario("Dubai cargo holds", "Amira", "Boeing 777F")
     |> assign(:holds, holds)
     |> assign(:sealed_count, length(holds))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto queries and contexts · 02 · Dubai cargo holds
      </p>

      <h1>Dubai cargo holds</h1>
      <p class="lede">
        Clerk {@clerk} pipes sealed {@craft} holds through where and order_by
        before Repo.all.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="sealed-count">{@sealed_count}</p>

      <ul id="sealed-holds">
        <li :for={hold <- @holds} id={"hold-#{hold.id}"}>
          <span class="hold-code">{hold.hold_code}</span> · {hold.kilograms} kg
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
