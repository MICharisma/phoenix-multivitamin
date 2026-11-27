defmodule PhoenixMultivitaminWeb.PantelleriaDeskSocket do
  use Phoenix.Socket

  channel "pantelleria:anemometers", PhoenixMultivitaminWeb.PantelleriaDeskChannel

  @impl true
  def connect(_params, socket, _connect_info),
    do: {:ok, assign(socket, :desk, "Pantelleria met desk")}

  @impl true
  def id(_socket), do: nil
end
