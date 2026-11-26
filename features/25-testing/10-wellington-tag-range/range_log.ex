# Testing · 10 · Wellington range log
#
# Teaches:
# - A plain module keeps Cook Strait range lines for tagged ExUnit setups

defmodule PhoenixMultivitamin.WellingtonRangeLog do
  @moduledoc false

  defstruct [:sector, :craft, :souls]

  def open!(sector) when sector in [:cook, :harbour] do
    %__MODULE__{sector: sector, craft: nil, souls: 0}
  end

  def board(%__MODULE__{} = log, craft, souls)
      when is_binary(craft) and is_integer(souls) and souls > 0 do
    %{log | craft: craft, souls: souls}
  end

  def label(%__MODULE__{sector: :cook, craft: craft, souls: souls})
      when is_binary(craft) do
    "Cook Strait · #{craft} · #{souls} souls"
  end

  def label(%__MODULE__{sector: :harbour, craft: craft, souls: souls})
      when is_binary(craft) do
    "Harbour · #{craft} · #{souls} souls"
  end

  def label(%__MODULE__{sector: sector}) do
    "#{sector} · empty"
  end
end
