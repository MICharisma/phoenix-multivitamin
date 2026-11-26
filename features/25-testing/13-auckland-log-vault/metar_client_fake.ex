# Testing · 13 · Auckland METAR fake
#
# Teaches:
# - A Fake module implements the behaviour without Mox

defmodule PhoenixMultivitamin.AucklandMetarClient.Fake do
  @moduledoc false
  @behaviour PhoenixMultivitamin.AucklandMetarClient

  @impl true
  def fetch(station) do
    case station do
      "NZAA" ->
        {:ok,
         %{
           station: "NZAA",
           wind: "24012KT",
           observer: "Mere",
           craft: "A320"
         }}

      other ->
        {:error, {:unknown_station, other}}
    end
  end
end
