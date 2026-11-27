defmodule PhoenixMultivitaminWeb.GotlandRadioNet do
  @moduledoc false
  @enforce_keys [:stations]
  defstruct [:stations]

  def from_presences(presences) do
    stations =
      Map.new(presences, fn {call_sign, %{metas: metas} = presence} ->
        {call_sign,
         %{
           site: presence.site,
           operator: presence.operator,
           frequencies: metas |> Enum.map(& &1.frequency) |> Enum.uniq() |> Enum.sort(),
           consoles: length(metas)
         }}
      end)

    %__MODULE__{stations: stations}
  end

  def changes(%__MODULE__{stations: before}, %__MODULE__{stations: now}) do
    call_signs = Map.keys(before) ++ Map.keys(now)

    call_signs
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.flat_map(&station_changes(&1, before[&1], now[&1]))
  end

  defp station_changes(call_sign, nil, station), do: [{:joined, call_sign, station.site}]
  defp station_changes(call_sign, _station, nil), do: [{:left, call_sign}]

  defp station_changes(call_sign, before, now) do
    [
      now.consoles > before.consoles && {:console_opened, call_sign, now.consoles},
      now.consoles < before.consoles && {:console_closed, call_sign, now.consoles},
      now.frequencies != before.frequencies && {:retuned, call_sign, now.frequencies}
    ]
    |> Enum.filter(& &1)
  end
end
