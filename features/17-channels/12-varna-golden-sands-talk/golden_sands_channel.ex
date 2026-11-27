defmodule PhoenixMultivitaminWeb.VarnaGoldenSandsChannel do
  use Phoenix.Channel

  alias PhoenixMultivitaminWeb.VarnaSlotDesk

  @impl true
  def join("golden_sands:slots", payload, socket) do
    latency_ms = payload |> Map.get("network_latency_ms", 1_200) |> min(5_000) |> max(0)

    {:ok, %{handler: socket.assigns.handler, network_latency_ms: latency_ms},
     assign(socket, latency_ms: latency_ms, pending: %{})}
  end

  @impl true
  def handle_in(
        "request_ctot",
        %{"flight" => flight, "eobt" => eobt, "destination" => destination},
        socket
      ) do
    with :free <- slot_request_state(socket.assigns.pending, flight),
         {:ok, eobt} <- Time.from_iso8601(eobt <> ":00") do
      task =
        Task.async(VarnaSlotDesk, :calculate, [
          flight,
          eobt,
          destination,
          socket.assigns.latency_ms
        ])

      pending = Map.put(socket.assigns.pending, task.ref, {flight, socket_ref(socket)})
      {:noreply, assign(socket, :pending, pending)}
    else
      :pending ->
        {:reply, {:error, %{flight: flight, reason: "CTOT already requested"}}, socket}

      {:error, _format} ->
        {:reply, {:error, %{flight: flight, reason: "EOBT must be HH:MM"}}, socket}
    end
  end

  @impl true
  def handle_info({ref, result}, %{assigns: %{pending: pending}} = socket)
      when is_map_key(pending, ref) do
    Process.demonitor(ref, [:flush])
    {{_flight, slot_request}, pending} = Map.pop!(pending, ref)
    reply(slot_request, result)
    {:noreply, assign(socket, :pending, pending)}
  end

  def handle_info({:DOWN, ref, :process, _pid, reason}, %{assigns: %{pending: pending}} = socket)
      when is_map_key(pending, ref) do
    {{flight, slot_request}, pending} = Map.pop!(pending, ref)

    reply(
      slot_request,
      {:error, %{flight: flight, reason: "slot desk fault: #{inspect(reason)}"}}
    )

    {:noreply, assign(socket, :pending, pending)}
  end

  defp slot_request_state(pending, flight) do
    if Enum.any?(pending, &match?({_ref, {^flight, _slot_request}}, &1)),
      do: :pending,
      else: :free
  end
end
