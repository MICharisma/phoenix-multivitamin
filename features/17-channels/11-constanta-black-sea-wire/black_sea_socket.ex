defmodule PhoenixMultivitaminWeb.ConstantaBlackSeaSocket do
  use Phoenix.Socket

  channel "black_sea:tracks", PhoenixMultivitaminWeb.ConstantaBlackSeaChannel

  @impl true
  def connect(_params, socket, _connect_info), do: {:ok, socket}

  @impl true
  def id(_socket), do: nil
end
