# Testing · 12 · Taupō volcanic beacon
#
# Teaches:
# - A GenServer pings subscribers with volcanic beacon ticks
# - Tests use assert_receive, never Process.sleep

defmodule PhoenixMultivitamin.TaupoBeacon do
  @moduledoc false
  use GenServer

  defstruct [:callsign, :subscribers]

  def start_link(callsign) when is_binary(callsign) do
    GenServer.start_link(__MODULE__, callsign)
  end

  def subscribe(server) when is_pid(server) do
    GenServer.call(server, {:subscribe, self()})
  end

  def ping(server, note) when is_pid(server) and is_binary(note) do
    GenServer.cast(server, {:ping, note})
  end

  @impl true
  def init(callsign) do
    {:ok, %__MODULE__{callsign: callsign, subscribers: MapSet.new()}}
  end

  @impl true
  def handle_call({:subscribe, pid}, _from, state) do
    Process.monitor(pid)
    {:reply, :ok, %{state | subscribers: MapSet.put(state.subscribers, pid)}}
  end

  @impl true
  def handle_cast({:ping, note}, state) do
    message = {:taupo_beacon, state.callsign, note}

    for pid <- state.subscribers do
      send(pid, message)
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {:noreply, %{state | subscribers: MapSet.delete(state.subscribers, pid)}}
  end
end
