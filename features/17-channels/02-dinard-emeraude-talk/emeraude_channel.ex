defmodule PhoenixMultivitaminWeb.DinardEmeraudeChannel do
  use Phoenix.Channel

  @stands ~w(1 2 3)
  @turnaround ~r/\AFR\d{3,4}\z/

  @impl true
  def join(
        "emeraude:stand:" <> stand,
        %{"turnaround" => flight},
        %{assigns: %{crew: crew}} = socket
      )
      when stand in @stands do
    cond do
      stand not in crew.stands ->
        {:error, %{reason: "#{crew.name} is not rostered on stand #{stand}"}}

      not Regex.match?(@turnaround, flight) ->
        {:error, %{reason: "#{flight} is not a Dinard turnaround today"}}

      true ->
        {:ok, %{stand: stand, flight: flight, crew: crew.name},
         assign(socket, stand: stand, flight: flight)}
    end
  end

  def join("emeraude:stand:" <> stand, %{"turnaround" => _flight}, _socket) do
    {:error, %{reason: "Dinard has no stand #{stand}"}}
  end

  def join(_topic, _payload_without_turnaround, _socket) do
    {:error, %{reason: "name the turnaround before joining a stand"}}
  end

  @impl true
  def handle_in("chocks_on", _payload, %{assigns: %{crew: %{role: role}}} = socket)
      when role in [:ramp_lead, :marshaller] do
    broadcast!(socket, "chocks_on", %{
      stand: socket.assigns.stand,
      flight: socket.assigns.flight,
      by: socket.assigns.crew.name
    })

    {:reply, :ok, socket}
  end

  def handle_in("chocks_on", _payload, socket) do
    {:reply, {:error, %{reason: "only the ramp lead or marshaller calls chocks"}}, socket}
  end
end
