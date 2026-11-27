defmodule PhoenixMultivitaminWeb.FigariBonifacioSocket do
  use Phoenix.Socket

  channel "figari:apron", PhoenixMultivitaminWeb.FigariBonifacioChannel

  @impl true
  def connect(%{"unit" => unit}, socket) when unit in ["marshal", "fuel_truck", "fire_tender"] do
    {:ok, assign(socket, :unit, unit)}
  end

  def connect(_params, _socket), do: :error

  @impl true
  def id(_socket), do: nil
end
