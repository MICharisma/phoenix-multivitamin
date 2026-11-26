# Telemetry and LiveDashboard · 13 · Mayotte lagoon metrics
#
# Teaches:
# - A station metrics module gathers counter, sum, last_value, summary, and distribution
# - LiveDashboard's metrics: option consumes this list beside the app defaults

defmodule PhoenixMultivitaminWeb.MayotteLagoonMetrics do
  @moduledoc false
  import Telemetry.Metrics

  @crossing [:mayotte, :lagoon, :ferry_crossing]
  @depth [:mayotte, :lagoon, :depth_metres]
  @clearance [:mayotte, :lagoon, :slot_clearance]

  def crossing_event, do: @crossing
  def depth_event, do: @depth
  def clearance_event, do: @clearance

  def dashboard_metrics do
    [
      counter("mayotte.lagoon.ferry_crossing.count",
        event_name: @crossing,
        description: "Lagoon ferry crossings counted at Dzaoudzi"
      ),
      sum("mayotte.lagoon.ferry_crossing.passengers",
        event_name: @crossing,
        measurement: :passengers,
        description: "Passengers moved across the Mayotte lagoon"
      ),
      last_value("mayotte.lagoon.depth_metres.depth",
        event_name: @depth,
        measurement: :depth,
        description: "Latest lagoon depth reading in metres"
      ),
      summary("mayotte.lagoon.slot_clearance.duration",
        event_name: @clearance,
        measurement: :duration,
        unit: {:native, :millisecond},
        tags: [:quay],
        tag_values: &quay_tags/1,
        description: "Slot clearance duration by quay"
      ),
      distribution("mayotte.lagoon.slot_clearance.duration",
        event_name: @clearance,
        measurement: :duration,
        unit: {:native, :millisecond},
        tags: [:quay],
        tag_values: &quay_tags/1,
        reporter_options: [buckets: [5, 15, 30, 60]],
        description: "Slot clearance distribution by quay"
      )
    ]
  end

  def cross_ferry(ferry, passengers)
      when is_binary(ferry) and is_integer(passengers) and passengers > 0 do
    :telemetry.execute(
      @crossing,
      %{passengers: passengers},
      %{ferry: ferry, station: "Dzaoudzi–Pamandzi", lagoon: "Mayotte"}
    )

    {:ok, passengers}
  end

  def cross_ferry(_ferry, passengers) when passengers <= 0, do: {:error, :empty_ferry}

  def sound_depth(metres) when is_number(metres) and metres > 0 do
    :telemetry.execute(@depth, %{depth: metres}, %{lagoon: "Mayotte", unit: :metre})
    {:ok, metres}
  end

  def sound_depth(_), do: {:error, :invalid_depth}

  def clear_slot(quay, duration_ms)
      when is_binary(quay) and is_integer(duration_ms) and duration_ms > 0 do
    duration = System.convert_time_unit(duration_ms, :millisecond, :native)

    :telemetry.execute(
      @clearance,
      %{duration: duration},
      %{quay: quay, station: "Dzaoudzi–Pamandzi"}
    )

    {:ok, %{quay: quay, duration_ms: duration_ms}}
  end

  def clear_slot(_quay, _), do: {:error, :bad_slot}

  def metric_kinds do
    dashboard_metrics()
    |> Enum.map(fn %mod{} -> metric_kind(mod) end)
    |> Enum.uniq()
  end

  defp quay_tags(%{quay: quay}), do: %{quay: quay}
  defp quay_tags(_), do: %{quay: "unknown"}

  defp metric_kind(Telemetry.Metrics.Counter), do: :counter
  defp metric_kind(Telemetry.Metrics.Sum), do: :sum
  defp metric_kind(Telemetry.Metrics.LastValue), do: :last_value
  defp metric_kind(Telemetry.Metrics.Summary), do: :summary
  defp metric_kind(Telemetry.Metrics.Distribution), do: :distribution
end
