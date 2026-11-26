defmodule PhoenixMultivitaminWeb.OhridLakeSocket do
  use Phoenix.Socket

  channel "ohrid:tower", PhoenixMultivitaminWeb.OhridTowerChannel
  channel "ohrid:*", PhoenixMultivitaminWeb.OhridLakeChannel

  @impl true
  def connect(%{"callsign" => callsign}, socket, _connect_info),
    do: {:ok, assign(socket, :callsign, callsign)}

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(_socket), do: nil
end
