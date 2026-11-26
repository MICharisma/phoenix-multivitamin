# PubSub · 07 · Doha Pearl floor bell
#
# Teaches:
# - Endpoint.subscribe/1 and Endpoint.broadcast!/3 use the endpoint's configured :pubsub_server
# - Endpoint broadcasts arrive as %Phoenix.Socket.Broadcast{} structs, matched by event
# - The local PG2 adapter here; a Redis adapter changes the child spec, not this code

defmodule PhoenixMultivitaminWeb.DohaPearlFloorBellLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Endpoint

  @topic "doha:pearl-transfer-floor"
  @gates ~w(C1 C12 D4 E21)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Endpoint.subscribe(@topic)

    {:ok,
     socket
     |> assign_scenario("Doha Pearl floor bell", "Maryam", "Boeing 777-300ER")
     |> assign(
       pubsub_server: Endpoint.config(:pubsub_server),
       gates: @gates,
       ringing: MapSet.new(),
       bell_log: []
     )}
  end

  @impl true
  def handle_event("ring_bell", %{"gate" => gate}, socket) when gate in @gates do
    Endpoint.broadcast!(@topic, "ring", %{gate: gate, rung_by: socket.assigns.clerk})
    {:noreply, socket}
  end

  def handle_event("ring_bell", _params, socket) do
    {:noreply, put_flash(socket, :error, "That gate is not on the Pearl transfer floor")}
  end

  def handle_event("silence_bell", %{"gate" => gate}, socket) do
    Endpoint.broadcast!(@topic, "silence", %{gate: gate})
    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "ring", payload: %{gate: gate, rung_by: who}}, socket) do
    {:noreply,
     socket
     |> update(:ringing, &MapSet.put(&1, gate))
     |> update(:bell_log, &["#{who} rang #{gate}" | &1])}
  end

  def handle_info(%Broadcast{event: "silence", payload: %{gate: gate}}, socket) do
    {:noreply, update(socket, :ringing, &MapSet.delete(&1, gate))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 07 · Doha Pearl floor bell
      </p>
      <header class="masthead">
        <h1>Doha Pearl floor bell</h1>
        <p class="lede">
          {@clerk} rings the transfer-floor bell at Hamad when a gate needs a wheelchair team.
          Every supervisor screen on the floor lights the same gate.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>PubSub server</dt>
        <dd id="pubsub-server">{inspect(@pubsub_server)}</dd>
      </dl>

      <div class="scenario my-6 grid gap-3 sm:grid-cols-2">
        <div :for={gate <- @gates} id={"gate-#{gate}"}
          class={["rounded-lg border p-3", MapSet.member?(@ringing, gate) && "border-red-800 bg-red-50 ringing"]}>
          <strong>{gate}</strong>
          <button id={"ring-#{gate}"} type="button" phx-click="ring_bell" phx-value-gate={gate}
            class="ml-3 rounded bg-green-900 px-3 py-1 text-white transition hover:bg-green-800">
            Ring
          </button>
          <button id={"silence-#{gate}"} type="button" phx-click="silence_bell" phx-value-gate={gate}
            class="ml-1 rounded border border-stone-400 px-3 py-1 transition hover:bg-stone-100">
            Silence
          </button>
        </div>
      </div>

      <ol id="bell-log" class="watch-log">
        <li :for={line <- @bell_log}>{line}</li>
      </ol>
    </Layouts.app>
    """
  end
end
