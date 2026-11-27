defmodule PhoenixMultivitaminWeb.KotorBayRadioRoomTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.KotorBaySocket

  defp tune_in(operator, position) do
    {:ok, socket} = connect(KotorBaySocket, %{operator: operator, position: position})
    {:ok, %{position: ^position}, room} = subscribe_and_join(socket, "kotor:radio_room")
    _ = :sys.get_state(room.channel_pid)
    Process.unlink(room.channel_pid)
    {room, Process.monitor(room.channel_pid)}
  end

  test "leaving runs terminate/2 with {:shutdown, :left}" do
    {room, monitor} = tune_in("Jelena Vujošević", "Tivat Tower")
    leave(room)

    assert_receive {:DOWN, ^monitor, :process, _pid, {:shutdown, :left}}

    assert_broadcast "operator_off", %{
      operator: "Jelena Vujošević",
      why: "signed off the frequency"
    }
  end

  test "closing the socket runs terminate/2 with {:shutdown, :closed}" do
    {room, monitor} = tune_in("Jelena Vujošević", "Tivat Tower")
    close(room)

    assert_receive {:DOWN, ^monitor, :process, _pid, {:shutdown, :closed}}
    assert_broadcast "operator_off", %{why: "radio link lost"}
  end

  test "a hand-over replies before stopping with a custom shutdown reason" do
    {room, monitor} = tune_in("Jelena Vujošević", "Tivat Tower")
    ref = push(room, "hand_over", %{relief: "Marko Radulović"})

    assert_reply ref, :ok, %{relief: "Marko Radulović"}
    assert_receive {:DOWN, ^monitor, :process, _pid, {:shutdown, :handed_over}}
    assert_broadcast "operator_off", %{why: "handed over to Marko Radulović"}
  end

  test "the operator who left is not told; the one still in the room is" do
    {approach, _monitor} = tune_in("Vuk Marković", "Podgorica Approach")
    assert_broadcast "operator_on", %{operator: "Vuk Marković"}

    {tower, _monitor} = tune_in("Jelena Vujošević", "Tivat Tower")
    assert_push "operator_on", %{operator: "Jelena Vujošević", position: "Tivat Tower"}

    leave(tower)
    assert_push "operator_off", %{position: "Tivat Tower"}
    refute_push "operator_off", _second_copy

    push(approach, "transmit", %{call: "4O-AOA, descend to 4000 feet"})
    assert_push "transmission", %{position: "Podgorica Approach"}
  end

  test "connect without an operator is refused with a reason" do
    assert connect(KotorBaySocket, %{position: "Tivat Tower"}) == {:error, :no_operator}
  end

  test "the radio room offers each position" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/09-kotor-bay-radio-room")
    assert has_element?(view, "#kotor-radio-room option[value='Podgorica Approach']")
  end
end
