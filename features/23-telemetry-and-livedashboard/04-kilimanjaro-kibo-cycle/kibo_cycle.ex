# Telemetry and LiveDashboard · 04 · Kilimanjaro Kibo cycle
#
# Teaches:
# - Domain emitters list several event names under one station prefix
# - execute/3 still takes one event name per call; attach_many listens to the list

defmodule PhoenixMultivitaminWeb.KilimanjaroKiboCycle do
  @moduledoc false

  @ascent [:kilimanjaro, :kibo, :ascent]
  @descent [:kilimanjaro, :kibo, :descent]
  @summit [:kilimanjaro, :kibo, :summit]

  def ascent_event, do: @ascent
  def descent_event, do: @descent
  def summit_event, do: @summit

  def event_names do
    for phase <- [:ascent, :descent, :summit] do
      [:kilimanjaro, :kibo, phase]
    end
  end

  def fly(phase, altitude_ft)
      when phase in [:ascent, :descent, :summit] and is_integer(altitude_ft) and altitude_ft > 0 do
    event =
      case phase do
        :ascent -> @ascent
        :descent -> @descent
        :summit -> @summit
      end

    :telemetry.execute(
      event,
      %{altitude_ft: altitude_ft},
      %{station: "Kilimanjaro International", peak: "Kibo", craft: "Cessna Caravan"}
    )

    {:ok, %{phase: phase, altitude_ft: altitude_ft}}
  end

  def fly(_phase, altitude_ft) when altitude_ft <= 0 do
    {:error, :grounded}
  end

  def with_handler(handler_id, destination, fun) when is_function(fun, 0) do
    :ok =
      :telemetry.attach_many(
        handler_id,
        event_names(),
        fn event, measurements, _metadata, pid ->
          send(pid, {:kibo_heard, List.last(event), measurements.altitude_ft})
        end,
        destination
      )

    try do
      fun.()
    after
      :telemetry.detach(handler_id)
    end
  end
end
