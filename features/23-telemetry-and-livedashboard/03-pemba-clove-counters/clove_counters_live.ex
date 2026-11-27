# Telemetry and LiveDashboard · 03 · Pemba clove counters
#
# Teaches:
# - Metric definitions are plain structs reporters and LiveDashboard consume
# - Enum.reduce/3 tallies kilograms locally while counter/sum name the same event

defmodule PhoenixMultivitaminWeb.PembaCloveCountersLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.PembaCloveCounters

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Pemba clove counters", "Mwanaidi", "DHC-6 Twin Otter")
     |> assign(:island, "Pemba")
     |> assign(:metric_cards, PembaCloveCounters.describe_metrics())
     |> assign(:sacks, [])
     |> assign(:sack_count, 0)
     |> assign(:kilogram_total, 0)}
  end

  @impl true
  def handle_event("weigh_sack", %{"lot" => lot, "kilograms" => kilograms}, socket) do
    kilograms =
      case Float.parse(String.trim(kilograms)) do
        {value, ""} -> value
        _ -> 0.0
      end

    socket =
      case PembaCloveCounters.weigh(lot, kilograms) do
        {:ok, sack} ->
          socket
          |> update(:sacks, &[sack | &1])
          |> update(:sack_count, &(&1 + 1))
          |> update(:kilogram_total, &(&1 + sack.kilograms))

        {:error, :empty_sack} ->
          put_flash(socket, :error, "A clove sack needs a positive weight.")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 03 · Pemba clove counters
      </p>

      <h1>Pemba clove counters</h1>
      <p class="lede">
        {@clerk} weighs clove lots on {@island} before the Twin Otter leaves for Zanzibar.
        <code>counter/2</code>
        counts weighings; <code>sum/2</code>
        totals kilograms.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="metric-definitions" class="scenario">
        <h2>Telemetry.Metrics definitions</h2>
        <article :for={card <- @metric_cards} id={"metric-#{card.kind}"}>
          <h3>{card.name}</h3>
          <p>{card.description}</p>
          <p>kind={card.kind} measurement={inspect(card.measurement)}</p>
        </article>
      </div>

      <form id="weigh-form" phx-submit="weigh_sack">
        <label>
          Lot <input id="lot-input" type="text" name="lot" value="Kitogani A" />
        </label>
        <label>
          Kilograms <input id="kg-input" type="text" name="kilograms" value="18.5" />
        </label>
        <button id="weigh-sack" type="submit">Weigh sack</button>
      </form>

      <div class="scenario">
        <p id="sack-count">Sacks weighed: {@sack_count}</p>
        <p id="kilogram-total">Kilograms total: {@kilogram_total}</p>
        <ul id="sack-list">
          <li :for={sack <- @sacks}>{sack.lot} — {sack.kilograms} kg</li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
