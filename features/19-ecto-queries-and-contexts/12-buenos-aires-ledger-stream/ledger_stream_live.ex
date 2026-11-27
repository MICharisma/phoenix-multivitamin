# Ecto queries and contexts · 12 · Buenos Aires ledger stream
#
# Teaches:
# - Repo.stream inside a transaction reduces the ledger
# - LiveView shows the summed litres without holding every row

defmodule PhoenixMultivitaminWeb.BuenosAiresLedgerStreamLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.BuenosAiresLedgerDesk

  @impl true
  def mount(_params, _session, socket) do
    total = BuenosAiresLedgerDesk.sum_litres_in_transaction()

    {:ok,
     socket
     |> assign_scenario("Buenos Aires ledger stream", "Valentina", "Boeing 737-800")
     |> assign(:total_litres, total)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 12 · Buenos Aires ledger stream
      </p>

      <h1>Buenos Aires ledger stream</h1>
      <p class="lede">
        Clerk {@clerk} streams {@craft} fuel ledger lines inside a transaction
        and sums litres without loading the whole list first.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="total-litres">{@total_litres}</p>
    </Layouts.app>
    """
  end
end
