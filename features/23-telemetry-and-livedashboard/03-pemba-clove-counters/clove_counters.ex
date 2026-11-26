# Telemetry and LiveDashboard · 03 · Pemba clove counters
#
# Teaches:
# - Telemetry.Metrics.counter/2 counts executions, ignoring measurement values
# - Telemetry.Metrics.sum/2 accumulates a named measurement across events

defmodule PhoenixMultivitaminWeb.PembaCloveCounters do
  @moduledoc false
  import Telemetry.Metrics

  @event [:pemba, :clove, :sack_weighed]

  def event_name, do: @event

  def metrics do
    [
      counter("pemba.clove.sack_weighed.count",
        event_name: @event,
        description: "How many clove sacks Pemba weighed"
      ),
      sum("pemba.clove.sack_weighed.kilograms",
        event_name: @event,
        measurement: :kilograms,
        description: "Total clove kilograms across sacks"
      )
    ]
  end

  def weigh(lot, kilograms) when is_binary(lot) and is_number(kilograms) and kilograms > 0 do
    :telemetry.execute(@event, %{kilograms: kilograms}, %{lot: lot, island: "Pemba"})
    {:ok, %{lot: lot, kilograms: kilograms}}
  end

  def weigh(_lot, kilograms) when kilograms <= 0, do: {:error, :empty_sack}

  def describe_metrics do
    for %mod{} = metric <- metrics() do
      %{
        kind: metric_kind(mod),
        name: Enum.join(metric.name, "."),
        description: metric.description,
        measurement: metric.measurement
      }
    end
  end

  defp metric_kind(Telemetry.Metrics.Counter), do: :counter
  defp metric_kind(Telemetry.Metrics.Sum), do: :sum
end
