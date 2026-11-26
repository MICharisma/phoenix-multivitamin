defmodule PhoenixMultivitaminWeb.LampedusaTalkbackLog do
  @moduledoc false

  @transmissions [
    {"Manta 10-01", "Airborne Lampedusa, patrol box Lima, endurance five hours."},
    {"MRCC Roma", "Manta 10-01, report contact at 35 26N 012 08E."},
    {"Manta 10-01", "Contact: wooden boat, about forty persons, no life jackets."},
    {"MRCC Roma", "CP 312 tasked, ETA forty minutes. Keep overhead."},
    {"Manta 10-01", "Bingo fuel in thirty, request relief by Manta 10-02."},
    {"Lampedusa Radio", "Manta 10-02 airborne, overhead in twenty-five."}
  ]

  def transmissions do
    @transmissions
    |> Enum.with_index(1)
    |> Enum.map(fn {{station, text}, seq} -> %{seq: seq, station: station, text: text} end)
  end

  def head_seq, do: length(@transmissions)

  def since(last_seq), do: for(entry <- transmissions(), entry.seq > last_seq, do: entry)
end
