defmodule PhoenixMultivitaminWeb.KotorBaySocket do
  use Phoenix.Socket

  channel "kotor:radio_room", PhoenixMultivitaminWeb.KotorBayChannel

  @impl true
  def connect(%{"operator" => operator} = params, socket, _connect_info) do
    {:ok,
     assign(socket, operator: operator, position: Map.get(params, "position", "Tivat Tower"))}
  end

  def connect(_params, _socket, _connect_info), do: {:error, :no_operator}

  @impl true
  def id(_socket), do: nil
end
