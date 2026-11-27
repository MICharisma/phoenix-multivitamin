# Telemetry and LiveDashboard · 05 · Lilongwe lake counts
#
# Teaches:
# - defstruct with @enforce_keys models a visibility reading before emit
# - Domain structs keep metres and waterbody out of ad-hoc maps

defmodule PhoenixMultivitaminWeb.LilongweLakeReading do
  @moduledoc false

  @enforce_keys [:metres, :waterbody]
  defstruct [:metres, :waterbody, station: "Lilongwe International"]

  def new(metres, waterbody)
      when is_number(metres) and metres >= 0 and is_binary(waterbody) do
    {:ok, %__MODULE__{metres: metres, waterbody: waterbody}}
  end

  def new(_metres, _waterbody), do: {:error, :invalid_reading}

  def band(%__MODULE__{metres: metres}) do
    case metres do
      m when m >= 10_000 -> :clear
      m when m >= 5_000 -> :haze
      m when m >= 1_000 -> :mist
      _ -> :fog
    end
  end
end
