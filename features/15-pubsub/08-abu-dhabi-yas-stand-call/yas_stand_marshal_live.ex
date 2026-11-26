defmodule PhoenixMultivitaminWeb.YasStandMarshalLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @marshals %{"31" => "Rashid", "32" => "Joseph"}

  @impl true
  def mount(:not_mounted_at_router, %{"stand" => stand, "topic" => topic}, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, topic)

    {:ok,
     assign(socket,
       stand: stand,
       topic: topic,
       marshal: Map.fetch!(@marshals, stand),
       inbound: nil
     ), layout: false}
  end

  @impl true
  def handle_event("marshal_ready", _params, %{assigns: %{inbound: flight}} = socket)
      when is_binary(flight) do
    %{stand: stand, marshal: marshal, topic: topic} = socket.assigns
    Phoenix.PubSub.broadcast!(PhoenixMultivitamin.PubSub, topic, {:marshal_ready, stand, marshal})
    {:noreply, socket}
  end

  def handle_event("marshal_ready", _params, socket), do: {:noreply, socket}

  @impl true
  def handle_info(message, socket) do
    stand = socket.assigns.stand

    case message do
      {:stand_call, ^stand, flight} -> {:noreply, assign(socket, :inbound, flight)}
      _other_stand_or_reply -> {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section id={"marshal-panel-#{@stand}"} class="scenario">
      <h2>Stand {@stand} · {@marshal}</h2>
      <p id={"inbound-#{@stand}"}>{@inbound || "No aircraft called"}</p>
      <button :if={@inbound} id={"ready-#{@stand}-button"} type="button" phx-click="marshal_ready"
        class="rounded-lg bg-green-900 px-4 py-2 text-white transition hover:bg-green-800">
        Wands up for {@inbound}
      </button>
    </section>
    """
  end
end
