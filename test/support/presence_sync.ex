defmodule PhoenixMultivitaminWeb.PresenceSync do
  @moduledoc """
  Test synchronization for the Presence feature.

  A tracker shard computes each presence diff in a fetch task and broadcasts
  it when the task replies. `settle/2` waits for that pipeline to drain, then
  flushes each LiveView with `:sys.get_state/1` so PubSub messages already in
  its mailbox are handled before the next assertion.
  """
  import ExUnit.Assertions

  alias Phoenix.Tracker.Shard

  def settle(presence, views \\ []) do
    drain_tracker(presence)

    for view <- List.wrap(views) do
      _ = :sys.get_state(view.pid)
    end

    :ok
  end

  def track_peer(presence, topic, key, meta, views \\ []) do
    peer = spawn(fn -> receive do: (:sign_off -> :ok) end)
    {:ok, _ref} = presence.track(peer, topic, key, meta)
    ExUnit.Callbacks.on_exit(fn -> drop(presence, peer) end)
    settle(presence, views)
    peer
  end

  def release_on_exit(%{pid: pid}, presence) do
    ExUnit.Callbacks.on_exit(fn -> drop(presence, pid) end)
  end

  def drop(presence, pid, views \\ []) do
    Process.exit(pid, :kill)
    await_exit(pid)
    settle(presence, views)
  end

  defp drain_tracker(presence) do
    case :sys.get_state(Shard.name_for_number(presence, 0)) do
      %{tracker_state: %{current_task: nil}} ->
        :ok

      %{tracker_state: %{current_task: {_ref, %Task{pid: fetcher}}}} ->
        await_exit(fetcher)
        drain_tracker(presence)
    end
  end

  defp await_exit(pid) do
    ref = Process.monitor(pid)
    assert_receive {:DOWN, ^ref, :process, ^pid, _reason}, 1_000
  end
end
