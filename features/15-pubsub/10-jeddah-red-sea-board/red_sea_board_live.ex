# PubSub · 10 · Jeddah Red Sea board
#
# Teaches:
# - Broadcast the change ({:gate_moved, flight, gate}), not the whole flight with its manifest
# - :erlang.external_size/1 measures what a subscriber would copy for each payload
# - A multi-clause anonymous function with a pinned flight number rewrites one board row

defmodule PhoenixMultivitaminWeb.JeddahRedSeaBoardLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @topic "jeddah:red-sea-gates"

  @flights [
    {"SV1021", "Riyadh", "A12"},
    {"SV1458", "Madinah", "B3"},
    {"XY204", "Cairo", "C27"}
  ]

  @manifest for row <- 1..40, seat <- ~w(A B C D E F), do: "#{row}#{seat}"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    board =
      for {number, destination, gate} <- @flights do
        %{number: number, destination: destination, gate: gate, manifest: @manifest}
      end

    {:ok,
     socket
     |> assign_scenario("Jeddah Red Sea board", "Reem", "Boeing 787-10")
     |> assign(board: board, payload_sizes: nil)}
  end

  @impl true
  def handle_event("move_gate", %{"flight" => number, "gate" => gate}, socket) do
    with {:ok, gate} <- parse_gate(String.upcase(gate)),
         %{} = flight <- Enum.find(socket.assigns.board, &(&1.number == number)) do
      slim = {:gate_moved, number, gate}
      Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, slim)

      sizes = %{
        slim: :erlang.external_size(slim),
        full: :erlang.external_size({:flight_changed, %{flight | gate: gate}})
      }

      {:noreply, assign(socket, :payload_sizes, sizes)}
    else
      _rejected -> {:noreply, put_flash(socket, :error, "Use a Red Sea gate A1–D40 on a listed flight")}
    end
  end

  @impl true
  def handle_info({:gate_moved, number, gate}, socket) do
    board =
      Enum.map(socket.assigns.board, fn
        %{number: ^number} = flight -> %{flight | gate: gate}
        flight -> flight
      end)

    {:noreply, assign(socket, :board, board)}
  end

  defp parse_gate(<<terminal, digits::binary>>) when terminal in ?A..?D do
    case Integer.parse(digits) do
      {number, ""} when number in 1..40 -> {:ok, <<terminal>> <> Integer.to_string(number)}
      _not_a_stand -> :error
    end
  end

  defp parse_gate(_gate), do: :error

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 10 · Jeddah Red Sea board
      </p>
      <header class="masthead">
        <h1>Jeddah Red Sea board</h1>
        <p class="lede">
          {@clerk} moves gates at King Abdulaziz Terminal 1. Every desk already holds each
          flight's 240-seat manifest, so a gate move sends only the flight and the new gate.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <table id="red-sea-board" class="scenario my-6 w-full">
        <tr :for={flight <- @board} id={"flight-#{flight.number}"}>
          <td>{flight.number}</td>
          <td>{flight.destination}</td>
          <td class="gate">{flight.gate}</td>
          <td>{length(flight.manifest)} seats</td>
        </tr>
      </table>

      <form id="gate-form" phx-submit="move_gate" class="scenario flex flex-wrap gap-3">
        <select id="gate-flight" name="flight" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={flight <- @board} value={flight.number}>{flight.number}</option>
        </select>
        <input id="gate-new" name="gate" type="text" placeholder="D7"
          class="rounded-lg border border-stone-400 px-3 py-2" />
        <button id="move-gate" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Move gate
        </button>
      </form>

      <dl :if={@payload_sizes} id="payload-sizes" class="station-meta">
        <dt>Broadcast payload</dt>
        <dd id="slim-bytes">{@payload_sizes.slim} bytes</dd>
        <dt>Whole flight would be</dt>
        <dd id="full-bytes">{@payload_sizes.full} bytes</dd>
      </dl>
    </Layouts.app>
    """
  end
end
