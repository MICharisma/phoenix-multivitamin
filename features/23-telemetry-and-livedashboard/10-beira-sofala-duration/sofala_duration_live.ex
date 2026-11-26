# Telemetry and LiveDashboard · 10 · Beira Sofala duration
#
# Teaches:
# - A LiveView can trigger Repo.query and surface the decoded row
# - Repo query telemetry arrives as [:phoenix_multivitamin, :repo, :query]
# - Enum.reduce/3 tallies how many successful pings the board has logged

defmodule PhoenixMultivitaminWeb.BeiraSofalaDurationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.BeiraSofalaDuration

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Beira Sofala duration", "Esperança", "An-26")
     |> assign(:harbour, "Beira")
     |> assign(:province, "Sofala")
     |> assign(:pings, [])
     |> assign(:ping_total, 0)
     |> assign(:last_error, nil)}
  end

  @impl true
  def handle_event("ping_sofala", _params, socket) do
    socket =
      case BeiraSofalaDuration.run_ping() do
        {:ok, ping} ->
          socket
          |> update(:pings, &[ping | &1])
          |> assign(:ping_total, tally_pings([ping | socket.assigns.pings]))
          |> assign(:last_error, nil)

        {:error, reason} ->
          socket
          |> assign(:last_error, inspect(reason))
          |> put_flash(:error, "Sofala ping failed.")
      end

    {:noreply, socket}
  end

  def handle_event("discard_stale_pings", _params, socket) do
    {:noreply, socket |> assign(:pings, []) |> assign(:ping_total, 0)}
  end

  defp tally_pings(pings) do
    Enum.reduce(pings, 0, fn _ping, acc -> acc + 1 end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 10 · Beira Sofala duration
      </p>

      <h1>Beira Sofala duration</h1>
      <p class="lede">
        {@clerk} checks the An-26 freight desk at {@harbour} in {@province} with <code>SELECT 1</code>. Ecto emits
        <code>[:phoenix_multivitamin, :repo, :query]</code>
        with <code>total_time</code>
        and <code>query_time</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="watch-switcher">
        <button id="ping-sofala" type="button" phx-click="ping_sofala">
          Ping Sofala desk
        </button>
        <button id="discard-pings" type="button" phx-click="discard_stale_pings">
          Discard stale pings
        </button>
      </div>

      <p id="ping-total">Successful pings: {@ping_total}</p>
      <p :if={@last_error} id="ping-error">{@last_error}</p>

      <div id="ping-log" class="scenario">
        <h2>Ping results</h2>
        <p :if={@pings == []} id="empty-pings">No Sofala ping yet.</p>
        <ul>
          <li :for={{ping, index} <- Enum.with_index(@pings)} id={"ping-#{index}"}>
            {ping.column}={ping.value} · {ping.harbour}/{ping.province}
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
