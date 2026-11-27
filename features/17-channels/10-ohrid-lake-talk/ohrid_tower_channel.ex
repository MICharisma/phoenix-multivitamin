defmodule PhoenixMultivitaminWeb.OhridTowerChannel do
  use Phoenix.Channel

  @sectors ~w(ohrid:runway:02 ohrid:runway:20 ohrid:apron:1 ohrid:approach:lake ohrid:approach:galicica)

  @impl true
  def join("ohrid:tower", _payload, socket), do: {:ok, %{sectors: @sectors}, socket}

  @impl true
  def handle_in("close_sector", %{"sector" => sector}, socket) when sector in @sectors do
    PhoenixMultivitaminWeb.Endpoint.broadcast!(sector, "sector_closed", %{
      sector: sector,
      by: socket.assigns.callsign
    })

    {:reply, :ok, socket}
  end

  def handle_in("close_sector", %{"sector" => sector}, socket) do
    {:reply, {:error, %{reason: "#{sector} is not a sector the tower can close"}}, socket}
  end
end
