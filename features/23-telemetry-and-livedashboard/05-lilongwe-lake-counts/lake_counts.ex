# Telemetry and LiveDashboard · 05 · Lilongwe lake counts
#
# Teaches:
# - Telemetry.Metrics.last_value/2 keeps the latest gauge measurement
# - Emit visibility metres so a dashboard can show the current lake reading

defmodule PhoenixMultivitaminWeb.LilongweLakeCounts do
  @moduledoc false
  import Telemetry.Metrics

  alias PhoenixMultivitaminWeb.LilongweLakeReading

  @event [:lilongwe, :malawi, :visibility]

  def event_name, do: @event

  def metrics do
    [
      last_value("lilongwe.malawi.visibility.metres",
        event_name: @event,
        measurement: :metres,
        description: "Latest Lake Malawi visibility in metres"
      )
    ]
  end

  def report(%LilongweLakeReading{} = reading) do
    :telemetry.execute(
      @event,
      %{metres: reading.metres},
      %{
        waterbody: reading.waterbody,
        station: reading.station,
        band: LilongweLakeReading.band(reading)
      }
    )

    {:ok, reading}
  end

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

  defp metric_kind(Telemetry.Metrics.LastValue), do: :last_value
end
