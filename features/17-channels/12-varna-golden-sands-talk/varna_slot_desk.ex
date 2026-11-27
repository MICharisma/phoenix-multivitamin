defmodule PhoenixMultivitaminWeb.VarnaSlotDesk do
  @moduledoc false

  @taxi_minutes 12
  @regulations %{
    "EGKK" => {"EGKKA26", 35},
    "ESSA" => {"ESSAW26", 15},
    "EDDL" => {nil, 0},
    "EPWA" => {nil, 0}
  }

  def calculate(flight, %Time{} = eobt, destination, latency_ms) do
    Process.sleep(latency_ms)

    case Map.fetch(@regulations, destination) do
      {:ok, {regulation, delay_minutes}} ->
        ctot = Time.add(eobt, @taxi_minutes + delay_minutes, :minute)

        {:ok,
         %{
           flight: flight,
           ctot: Calendar.strftime(ctot, "%H:%M"),
           regulation: regulation,
           delay_min: delay_minutes
         }}

      :error ->
        {:error, %{flight: flight, reason: "no flight plan filed to #{destination}"}}
    end
  end
end
