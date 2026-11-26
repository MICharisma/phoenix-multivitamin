# Testing · 07 · Launceston tower channel
#
# Teaches:
# - join/3 authorizes the Tamar topic
# - handle_in/3 replies and broadcasts runway calls

defmodule PhoenixMultivitaminWeb.LauncestonTowerChannel do
  @moduledoc false
  use PhoenixMultivitaminWeb, :channel

  @impl true
  def join("tower:" <> runway, _payload, socket) when runway in ~w(14 32) do
    {:ok, %{runway: runway, desk: socket.assigns.desk}, assign(socket, :runway, runway)}
  end

  def join(_topic, _payload, _socket), do: {:error, %{reason: "unknown_runway"}}

  @impl true
  def handle_in("call_inbound", %{"craft" => craft}, socket) when is_binary(craft) do
    call = %{craft: craft, runway: socket.assigns.runway, desk: socket.assigns.desk}
    broadcast!(socket, "inbound_called", call)
    {:reply, {:ok, call}, socket}
  end

  def handle_in("call_inbound", _payload, socket) do
    {:reply, {:error, %{reason: "craft_required"}}, socket}
  end
end
