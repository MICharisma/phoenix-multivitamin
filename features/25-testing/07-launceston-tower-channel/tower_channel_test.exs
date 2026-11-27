defmodule PhoenixMultivitaminWeb.LauncestonTowerChannelTest do
  use PhoenixMultivitaminWeb.ChannelCase

  alias PhoenixMultivitaminWeb.LauncestonTowerSocket

  test "subscribe_and_join, push, assert_reply, and assert_broadcast" do
    {:ok, socket} = connect(LauncestonTowerSocket, %{"desk" => "north"})

    {:ok, reply, socket} = subscribe_and_join(socket, "tower:14", %{})
    assert reply == %{runway: "14", desk: "north"}

    ref = push(socket, "call_inbound", %{"craft" => "Saab 340"})
    assert_reply ref, :ok, %{craft: "Saab 340", runway: "14", desk: "north"}
    assert_broadcast "inbound_called", %{craft: "Saab 340", runway: "14"}
  end

  test "connect/2 returns :error for a desk outside north or south" do
    assert :error = connect(LauncestonTowerSocket, %{"desk" => "east"})
  end

  test "an unknown runway is refused on join" do
    {:ok, socket} = connect(LauncestonTowerSocket, %{"desk" => "south"})
    assert {:error, %{reason: "unknown_runway"}} = subscribe_and_join(socket, "tower:09", %{})
  end

  test "a missing craft returns an error reply" do
    {:ok, socket} = connect(LauncestonTowerSocket, %{"desk" => "north"})
    {:ok, _reply, socket} = subscribe_and_join(socket, "tower:32", %{})

    ref = push(socket, "call_inbound", %{})
    assert_reply ref, :error, %{reason: "craft_required"}
  end
end
