# Telemetry and LiveDashboard · 02 · Mombasa Moi duration
#
# Teaches:
# - :telemetry.span/3 emits EventPrefix ++ [start] then [stop] around a function
# - The span function returns {result, metadata} or {result, measurements, metadata}

defmodule PhoenixMultivitaminWeb.MombasaMoiTurnaround do
  @moduledoc false

  @prefix [:mombasa, :moi, :turnaround]

  def prefix, do: @prefix
  def start_event, do: @prefix ++ [:start]
  def stop_event, do: @prefix ++ [:stop]

  def run(stand, minutes) when is_binary(stand) and is_integer(minutes) and minutes > 0 do
    :telemetry.span(@prefix, %{stand: stand, airport: "Moi International"}, fn ->
      elapsed_native = System.convert_time_unit(minutes * 60, :second, :native)
      Process.sleep(0)

      result = %{stand: stand, minutes: minutes, status: :cleared}

      {result, %{duration: elapsed_native}, %{stand: stand, apron: "Terminal 1"}}
    end)
  end

  def run(_stand, minutes) when minutes <= 0 do
    {:error, :non_positive_turnaround}
  end
end
