defmodule PhoenixMultivitaminWeb.VarnaGoldenSandsSocket do
  use Phoenix.Socket

  channel "golden_sands:slots", PhoenixMultivitaminWeb.VarnaGoldenSandsChannel

  @impl true
  def connect(params, socket, _connect_info) do
    {:ok, assign(socket, :handler, params["handler"] || "Varna ramp office")}
  end

  @impl true
  def id(_socket), do: nil
end
