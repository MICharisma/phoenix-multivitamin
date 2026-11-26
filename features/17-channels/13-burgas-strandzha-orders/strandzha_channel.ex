defmodule PhoenixMultivitaminWeb.BurgasStrandzhaChannel do
  use Phoenix.Channel

  intercept ["drop_order"]

  @lz_grid %{
    "Sinemorets ridge" => %{grid: "SN-14", water_source: "Veleka mouth"},
    "Malko Tarnovo spur" => %{grid: "MT-07", water_source: "Rezovska bend"},
    "Strandzha peak" => %{grid: "ST-02", water_source: "Mandra reservoir"}
  }

  @impl true
  def join("strandzha:drops", %{"shift" => shift}, socket)
      when shift in ["morning", "afternoon", "night"] do
    %{role: role, callsign: callsign, user_agent: user_agent} = socket.assigns

    send(self(), {:after_join, shift})

    {:ok,
     %{
       role: role,
       callsign: callsign,
       shift: shift,
       user_agent: user_agent,
       landing_zones: Map.keys(@lz_grid)
     }, assign(socket, shift: shift, orders: 0)}
  end

  def join("strandzha:drops", _payload, _socket) do
    {:error, %{reason: "name the Strandzha shift before joining the drop net"}}
  end

  @impl true
  def handle_info({:after_join, shift}, socket) do
    broadcast_from!(socket, "net_join", %{
      role: socket.assigns.role,
      callsign: socket.assigns.callsign,
      shift: shift
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("order_drop", payload, %{assigns: %{role: "tower"}} = socket) do
    case Map.fetch(@lz_grid, payload["landing_zone"]) do
      {:ok, lz} ->
        order_no = socket.assigns.orders + 1

        order =
          Map.merge(lz, %{
            order_no: order_no,
            landing_zone: payload["landing_zone"],
            loads: payload["loads"] || 1,
            ordered_by: socket.assigns.callsign,
            fuel_state: payload["fuel_state"] || "unknown",
            radio_discrete: payload["radio_discrete"] || "122.450"
          })

        broadcast!(socket, "drop_order", order)
        {:reply, {:ok, %{order_no: order_no, grid: lz.grid}}, assign(socket, :orders, order_no)}

      :error ->
        {:reply, {:error, %{reason: "no landing zone on the Strandzha card"}}, socket}
    end
  end

  def handle_in("order_drop", _payload, socket) do
    {:reply, {:error, %{reason: "only Burgas Tower orders Strandzha drops"}}, socket}
  end

  def handle_in(
        "accept_drop",
        %{"order_no" => order_no},
        %{assigns: %{role: "helicopter"}} = socket
      ) do
    broadcast!(socket, "drop_accepted", %{
      order_no: order_no,
      by: socket.assigns.callsign
    })

    {:noreply, socket}
  end

  def handle_in("accept_drop", _payload, socket) do
    {:reply, {:error, %{reason: "only the helicopter accepts a drop"}}, socket}
  end

  @impl true
  def handle_out("drop_order", order, %{assigns: %{role: role}} = socket) do
    push(socket, "drop_order", redact(order, role))
    {:noreply, socket}
  end

  defp redact(order, "lookout"),
    do: Map.take(order, [:order_no, :landing_zone, :grid, :loads, :water_source])

  defp redact(order, _tower_or_helicopter), do: order
end
