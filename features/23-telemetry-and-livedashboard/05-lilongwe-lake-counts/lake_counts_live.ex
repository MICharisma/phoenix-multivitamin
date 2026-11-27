# Telemetry and LiveDashboard · 05 · Lilongwe lake counts
#
# Teaches:
# - last_value/2 is the Telemetry.Metrics gauge for the latest reading
# - case on visibility bands drives the board copy after each emit

defmodule PhoenixMultivitaminWeb.LilongweLakeCountsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.LilongweLakeCounts
  alias PhoenixMultivitaminWeb.LilongweLakeReading

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Lilongwe lake counts", "Chisomo", "ATR 42")
     |> assign(:station, "Lilongwe International")
     |> assign(:waterbody, "Lake Malawi")
     |> assign(:metric_cards, LilongweLakeCounts.describe_metrics())
     |> assign(:latest_label, nil)
     |> assign(:latest_band, nil)
     |> assign(:latest_metres, nil)}
  end

  @impl true
  def handle_event("report_visibility", %{"metres" => metres}, socket) do
    metres =
      case Float.parse(String.trim(metres)) do
        {value, ""} -> value
        _ -> -1.0
      end

    socket =
      with {:ok, reading} <- LilongweLakeReading.new(metres, socket.assigns.waterbody),
           {:ok, reading} <- LilongweLakeCounts.report(reading) do
        band = LilongweLakeReading.band(reading)

        socket
        |> assign(:latest_label, to_string(reading))
        |> assign(:latest_band, band)
        |> assign(:latest_metres, reading.metres)
      else
        {:error, :invalid_reading} ->
          put_flash(socket, :error, "Visibility metres must be zero or greater.")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 05 · Lilongwe lake counts
      </p>

      <h1>Lilongwe lake counts</h1>
      <p class="lede">
        {@clerk} posts {@waterbody} visibility from {@station} before the ATR 42 departs.
        <code>last_value/2</code>
        keeps the latest metres as a gauge.
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

      <form id="visibility-form" phx-submit="report_visibility">
        <label>
          Visibility metres <input id="metres-input" type="text" name="metres" value="8500" />
        </label>
        <button id="report-visibility" type="submit">Report visibility</button>
      </form>

      <div id="latest-reading" class="scenario">
        <h2>Latest gauge</h2>
        <%= case {@latest_metres, @latest_band} do %>
          <% {nil, _} -> %>
            <p id="empty-reading">No Lake Malawi reading yet.</p>
          <% {metres, band} -> %>
            <p id="reading-label">{@latest_label}</p>
            <p id="reading-metres">Metres: {trunc(metres)}</p>
            <p id="reading-band">Band: {band}</p>
        <% end %>
      </div>
    </Layouts.catalog>
    """
  end
end
