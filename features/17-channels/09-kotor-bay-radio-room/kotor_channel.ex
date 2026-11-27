defmodule PhoenixMultivitaminWeb.KotorBayChannel do
  use Phoenix.Channel

  @impl true
  def join(
        "kotor:radio_room",
        _payload,
        %{assigns: %{operator: operator, position: position}} = socket
      ) do
    send(self(), :after_join)
    {:ok, %{position: position}, assign(socket, operator: operator, position: position)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    broadcast_from!(socket, "operator_on", %{
      operator: socket.assigns.operator,
      position: socket.assigns.position
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("transmit", %{"call" => call}, socket) do
    broadcast!(socket, "transmission", %{position: socket.assigns.position, call: call})
    {:noreply, socket}
  end

  def handle_in("hand_over", %{"relief" => relief}, socket) do
    {:stop, {:shutdown, :handed_over}, {:ok, %{relief: relief}}, assign(socket, :relief, relief)}
  end

  @impl true
  def terminate(reason, %{assigns: assigns} = socket) do
    broadcast_from!(socket, "operator_off", %{
      operator: assigns.operator,
      position: assigns.position,
      why: sign_off(reason, assigns)
    })
  end

  defp sign_off({:shutdown, :left}, _assigns), do: "signed off the frequency"
  defp sign_off({:shutdown, :closed}, _assigns), do: "radio link lost"
  defp sign_off({:shutdown, :handed_over}, %{relief: relief}), do: "handed over to #{relief}"
  defp sign_off(_crash, _assigns), do: "radio room fault"
end
