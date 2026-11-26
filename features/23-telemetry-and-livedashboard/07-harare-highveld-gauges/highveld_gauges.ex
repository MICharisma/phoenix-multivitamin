# Telemetry and LiveDashboard · 07 · Harare Highveld gauges
#
# Teaches:
# - Telemetry.Metrics.summary/2 and distribution/2 share one departure event
# - tags: [:runway] plus a tag_values capture derive runway from metadata

defmodule PhoenixMultivitaminWeb.HarareHighveldGauges do
  @moduledoc false
  import Telemetry.Metrics

  @event [:harare, :highveld, :departure]

  def event_name, do: @event

  def metrics do
    [
      summary("harare.highveld.departure.roll_ms",
        event_name: @event,
        measurement: :roll_ms,
        tags: [:runway],
        tag_values: &runway_tags/1,
        description: "Highveld takeoff roll summary by runway"
      ),
      distribution("harare.highveld.departure.roll_ms",
        event_name: @event,
        measurement: :roll_ms,
        tags: [:runway],
        tag_values: &runway_tags/1,
        reporter_options: [buckets: [20_000, 30_000, 40_000, 50_000]],
        description: "Highveld takeoff roll distribution by runway"
      )
    ]
  end

  def depart(%{flight: flight, runway: runway, roll_ms: roll_ms})
      when is_binary(flight) and is_binary(runway) and is_integer(roll_ms) and roll_ms > 0 do
    :telemetry.execute(
      @event,
      %{roll_ms: roll_ms},
      %{flight: flight, runway: runway, station: "Harare International", plateau: "Highveld"}
    )

    {:ok, %{flight: flight, runway: runway, roll_ms: roll_ms}}
  end

  def depart(%{roll_ms: roll_ms}) when roll_ms <= 0 do
    {:error, :no_roll}
  end

  def describe_metrics do
    for %mod{} = metric <- metrics() do
      %{
        kind: metric_kind(mod),
        name: Enum.join(metric.name, "."),
        description: metric.description,
        tags: metric.tags,
        measurement: metric.measurement
      }
    end
  end

  def group_by_runway(departures) do
    Enum.group_by(departures, fn
      %{runway: runway} -> runway
    end)
  end

  defp runway_tags(%{runway: runway}), do: %{runway: runway}
  defp runway_tags(_metadata), do: %{runway: "unknown"}

  defp metric_kind(Telemetry.Metrics.Summary), do: :summary
  defp metric_kind(Telemetry.Metrics.Distribution), do: :distribution
end
