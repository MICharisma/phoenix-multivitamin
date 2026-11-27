defmodule PhoenixMultivitaminWeb.LampedusaStraitChannel do
  use Phoenix.Channel

  alias PhoenixMultivitaminWeb.LampedusaTalkbackLog, as: Log

  @impl true
  def join("strait:talkback" = topic, payload, socket) when not is_map_key(payload, "last_seq") do
    join(topic, Map.put(payload, "last_seq", 0), socket)
  end

  def join("strait:talkback", %{"last_seq" => last_seq}, socket)
      when is_integer(last_seq) and last_seq >= 0 do
    head_seq = Log.head_seq()

    if last_seq > head_seq do
      {:error, %{reason: "last_seq is ahead of the strait log", head_seq: head_seq}}
    else
      %{operator: operator, console: console} = socket.assigns
      missed = Log.since(last_seq)

      socket =
        socket
        |> assign(acknowledged_seq: last_seq, head_seq: head_seq)
        |> assign(:signature, "#{console} · #{operator}")

      {:ok, %{missed: missed, head_seq: head_seq, signature: socket.assigns.signature}, socket}
    end
  end

  def join("strait:talkback", _payload, _socket) do
    {:error, %{reason: "last_seq must be a whole sequence number"}}
  end

  @impl true
  def handle_in(
        "acknowledge",
        %{"seq" => seq},
        %{assigns: %{acknowledged_seq: acknowledged}} = socket
      )
      when seq == acknowledged + 1 do
    {:reply, {:ok, %{acknowledged_seq: seq, by: socket.assigns.signature}},
     assign(socket, :acknowledged_seq, seq)}
  end

  def handle_in("acknowledge", %{"seq" => _out_of_order}, socket) do
    {:reply, {:error, %{expected_seq: socket.assigns.acknowledged_seq + 1}}, socket}
  end
end
