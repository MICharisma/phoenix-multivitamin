# Telemetry and LiveDashboard · 07 · Harare Highveld gauges
#
# Teaches:
# - summary/2 and distribution/2 with tags surface runway-scoped roll times
# - Enum.group_by clusters departures after tag_values derives the runway key

defmodule PhoenixMultivitaminWeb.HarareHighveldGaugesLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.HarareHighveldGauges

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Harare Highveld gauges", "Rudo", "Embraer 145")
     |> assign(:station, "Harare International")
     |> assign(:plateau, "Highveld")
     |> assign(:metric_cards, HarareHighveldGauges.describe_metrics())
     |> assign(:departures, [])
     |> assign(:by_runway, %{})}
  end

  @impl true
  def handle_event(
        "log_departure",
        %{"flight" => flight, "runway" => runway, "roll_ms" => roll},
        socket
      ) do
    roll_ms =
      case Integer.parse(String.trim(roll)) do
        {value, ""} -> value
        _ -> 0
      end

    socket =
      case HarareHighveldGauges.depart(%{flight: flight, runway: runway, roll_ms: roll_ms}) do
        {:ok, departure} ->
          departures = [departure | socket.assigns.departures]

          socket
          |> assign(:departures, Enum.take(departures, 12))
          |> assign(:by_runway, HarareHighveldGauges.group_by_runway(departures))

        {:error, :no_roll} ->
          put_flash(socket, :error, "Takeoff roll must be a positive millisecond count.")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 07 · Harare Highveld gauges
      </p>

      <h1>Harare Highveld gauges</h1>
      <p class="lede">
        {@clerk} times Embraer 145 rolls at {@station} on the {@plateau}. <code>summary/2</code>
        and <code>distribution/2</code>
        tag each roll by runway.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="metric-definitions" class="scenario">
        <h2>Telemetry.Metrics definitions</h2>
        <article :for={card <- @metric_cards} id={"metric-#{card.kind}"}>
          <h3>{card.name}</h3>
          <p>{card.description}</p>
          <p>kind={card.kind} tags={inspect(card.tags)} measurement={inspect(card.measurement)}</p>
        </article>
      </div>

      <div class="watch-switcher">
        <button
          id="depart-05"
          type="button"
          phx-click="log_departure"
          phx-value-flight="FN 814"
          phx-value-runway="05"
          phx-value-roll_ms="28500"
        >
          Depart runway 05
        </button>
        <button
          id="depart-17"
          type="button"
          phx-click="log_departure"
          phx-value-flight="FN 902"
          phx-value-runway="17"
          phx-value-roll_ms="31200"
        >
          Depart runway 17
        </button>
        <button
          id="depart-bad"
          type="button"
          phx-click="log_departure"
          phx-value-flight="FN 100"
          phx-value-runway="05"
          phx-value-roll_ms="0"
        >
          Refuse zero roll
        </button>
      </div>

      <div id="runway-groups" class="scenario">
        <h2>Departures by runway</h2>
        <p :if={@by_runway == %{}} id="empty-runways">No Highveld departure yet.</p>
        <%= for {runway, flights} <- @by_runway do %>
          <section id={"runway-#{runway}"}>
            <h3>Runway {runway}</h3>
            <ul>
              <li :for={departure <- flights}>
                {departure.flight} · {departure.roll_ms} ms
              </li>
            </ul>
          </section>
        <% end %>
      </div>
    </Layouts.catalog>
    """
  end
end
