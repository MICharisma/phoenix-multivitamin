defmodule PhoenixMultivitaminWeb.BrestIroiseChannel do
  use Phoenix.Channel

  @fluids %{"type_i" => 900, "type_iv" => 450}

  @impl true
  def join("iroise:deice:" <> registration, _payload, socket) do
    {:ok, %{registration: registration, stand: socket.assigns.stand},
     assign(socket, registration: registration, orders: [], truck_at: nil)}
  end

  @impl true
  def handle_in("order_fluid", %{"fluid" => fluid, "litres" => litres}, socket)
      when is_map_key(@fluids, fluid) and is_integer(litres) do
    ceiling = Map.fetch!(@fluids, fluid)

    cond do
      litres <= 0 ->
        {:reply, {:error, %{litres: "order at least one litre"}}, socket}

      litres > ceiling ->
        {:reply, {:error, %{litres: "#{fluid} is capped at #{ceiling} L for an ATR 72"}}, socket}

      true ->
        order = %{order_no: length(socket.assigns.orders) + 1, fluid: fluid, litres: litres}
        {:reply, {:ok, order}, assign(socket, :orders, [order | socket.assigns.orders])}
    end
  end

  def handle_in("order_fluid", %{"fluid" => fluid}, socket) when not is_map_key(@fluids, fluid) do
    {:reply, {:error, %{fluid: "Brest stocks type_i and type_iv only"}}, socket}
  end

  def handle_in("order_fluid", _payload, socket) do
    {:reply, {:error, %{litres: "send litres as a whole number"}}, socket}
  end

  def handle_in("acknowledge_truck", _payload, socket), do: {:reply, :ok, socket}

  def handle_in("truck_position", %{"bay" => bay}, socket) do
    {:noreply, assign(socket, :truck_at, bay)}
  end

  def handle_in("close_orders", _payload, %{assigns: %{orders: orders}} = socket) do
    summary = %{orders: length(orders), litres: Enum.sum_by(orders, & &1.litres)}
    {:stop, :normal, {:ok, summary}, socket}
  end
end
