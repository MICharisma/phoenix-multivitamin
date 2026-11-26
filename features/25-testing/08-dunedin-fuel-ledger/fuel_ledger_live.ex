# Testing · 08 · Dunedin fuel ledger
#
# Teaches:
# - The catalog page posts through the ledger; DataCase owns the lesson

defmodule PhoenixMultivitaminWeb.DunedinFuelLedgerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.DunedinFuelLedger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Dunedin fuel ledger", "Hamish", "ATR 72")
     |> assign(:totals, DunedinFuelLedger.litres_by_bay())}
  end

  @impl true
  def handle_event("post_otago", _params, socket) do
    {:ok, _entry} =
      DunedinFuelLedger.post_entry(%{
        clerk: socket.assigns.clerk,
        craft: socket.assigns.craft,
        litres: 2_400,
        bay: "otago"
      })

    {:noreply, assign(socket, :totals, DunedinFuelLedger.litres_by_bay())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 08 · Dunedin fuel ledger
      </p>

      <h1>Dunedin fuel ledger</h1>
      <p class="lede">
        Clerk {@clerk} posts ATR 72 litres into the Otago bay. DataCase tests
        write through the sandbox and roll back after each example.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="otago-total">{Map.get(@totals, "otago", 0)}</p>
      <button id="post-otago" type="button" phx-click="post_otago">Post Otago fuel</button>
    </Layouts.app>
    """
  end
end
