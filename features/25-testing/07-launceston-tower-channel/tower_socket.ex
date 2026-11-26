# Testing · 07 · Launceston tower socket
#
# Teaches:
# - A scenario-scoped UserSocket connects with a desk name

defmodule PhoenixMultivitaminWeb.LauncestonTowerSocket do
  @moduledoc false
  use Phoenix.Socket

  channel "tower:*", PhoenixMultivitaminWeb.LauncestonTowerChannel

  @impl true
  def connect(%{"desk" => desk}, socket, _connect_info) when desk in ~w(north south) do
    {:ok, assign(socket, :desk, desk)}
  end

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(socket), do: "launceston_tower:#{socket.assigns.desk}"
end
