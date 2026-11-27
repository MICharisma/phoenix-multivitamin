# Telemetry and LiveDashboard · 01 · Kisumu Winam metrics
#
# Teaches:
# - :telemetry.execute/3 emits a named event with measurements and metadata
# - Domain emitters keep the event prefix and keys out of the LiveView

defmodule PhoenixMultivitaminWeb.KisumuWinamEmitter do
  @moduledoc false

  @event [:kisumu, :winam, :ferry_crossed]

  def event_name, do: @event

  defstruct [:ferry, :passengers]

  def cross(%__MODULE__{ferry: ferry, passengers: passengers})
      when is_binary(ferry) and is_integer(passengers) and passengers > 0 do
    :telemetry.execute(
      @event,
      %{passengers: passengers},
      %{ferry: ferry, station: "Kisumu International", gulf: "Winam"}
    )

    {:ok, passengers}
  end

  def cross(%__MODULE__{passengers: passengers}) when passengers <= 0 do
    {:error, :empty_crossing}
  end
end
