defmodule PhoenixMultivitamin.TaupoBeaconTest do
  use ExUnit.Case, async: true

  alias PhoenixMultivitamin.TaupoBeacon

  test "assert_receive locks a volcanic ping without sleeping" do
    pid = start_supervised!({TaupoBeacon, "ZK-HNZ"})
    assert :ok = TaupoBeacon.subscribe(pid)

    TaupoBeacon.ping(pid, "ash plume drifting east of the caldera")

    assert_receive {:taupo_beacon, "ZK-HNZ", "ash plume drifting east of the caldera"}, 100
  end

  test "a second subscriber also receives the broadcast ping" do
    pid = start_supervised!({TaupoBeacon, "ZK-HNZ"})
    assert :ok = TaupoBeacon.subscribe(pid)
    parent = self()

    _subscriber =
      spawn_link(fn ->
        :ok = TaupoBeacon.subscribe(pid)
        send(parent, :subscribed)

        receive do
          {:taupo_beacon, callsign, note} ->
            send(parent, {:child_saw, callsign, note})
        after
          200 ->
            send(parent, :child_timeout)
        end
      end)

    assert_receive :subscribed, 100
    TaupoBeacon.ping(pid, "caldera quiet")

    assert_receive {:taupo_beacon, "ZK-HNZ", "caldera quiet"}, 100
    assert_receive {:child_saw, "ZK-HNZ", "caldera quiet"}, 100
    refute_receive :child_timeout
  end
end
