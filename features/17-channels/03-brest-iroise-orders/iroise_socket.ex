defmodule PhoenixMultivitaminWeb.BrestIroiseSocket do
  use Phoenix.Socket

  channel "iroise:deice:*", PhoenixMultivitaminWeb.BrestIroiseChannel

  @impl true
  def connect(%{"stand" => stand}, socket, _connect_info) when byte_size(stand) in 1..3 do
    {:ok, assign(socket, :stand, stand)}
  end

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(_socket), do: nil
end
