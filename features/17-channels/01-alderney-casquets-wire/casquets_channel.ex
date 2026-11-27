defmodule PhoenixMultivitaminWeb.AlderneyCasquetsChannel do
  use Phoenix.Channel

  @casquets_reading %{
    station: "Casquets lighthouse AWS",
    wind: "250/28G38KT",
    visibility_m: 4000,
    weather: "BR",
    sea_state: "rough"
  }

  @impl true
  def join("casquets:wire", _payload, socket) do
    %{dispatcher: dispatcher, desk: desk} = socket.assigns
    {:ok, %{dispatcher: dispatcher, desk: desk, reading: @casquets_reading}, socket}
  end
end
