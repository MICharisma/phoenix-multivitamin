# Telemetry and LiveDashboard · 08 · Gaborone Kalahari throughput
#
# Teaches:
# - telemetry_poller invokes an MFA on a period; that MFA must call :telemetry.execute/3
# - Telemetry.Metrics.last_value/2 keeps the latest apron aircraft count
# - An Agent holds the live count the measurement MFA reads

defmodule PhoenixMultivitaminWeb.GaboroneKalahariThroughput do
  @moduledoc false
  import Telemetry.Metrics

  @event [:gaborone, :kalahari, :apron_count]
  @agent __MODULE__.ApronCounter

  def event_name, do: @event
  def agent_name, do: @agent

  def start_counter do
    case Agent.start_link(fn -> 0 end, name: @agent) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
    end
  end

  def apron_count do
    Agent.get(@agent, & &1)
  end

  def park_aircraft do
    Agent.update(@agent, &(&1 + 1))
    apron_count()
  end

  def measure_apron do
    aircraft = apron_count()

    :telemetry.execute(
      @event,
      %{aircraft: aircraft},
      %{apron: "Kalahari", station: "Gaborone Sir Seretse Khama", craft: "CRJ-900"}
    )

    aircraft
  end

  def metrics do
    [
      last_value("gaborone.kalahari.apron_count.aircraft",
        event_name: @event,
        measurement: :aircraft,
        description: "Aircraft presently parked on the Kalahari apron"
      )
    ]
  end

  def describe_metric do
    [%mod{} = metric] = metrics()

    %{
      kind: :last_value,
      module: mod,
      name: Enum.join(metric.name, "."),
      measurement: metric.measurement,
      description: metric.description
    }
  end
end
