defmodule PhoenixMultivitaminWeb.LampedusaStraitTalkbackTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.LampedusaStraitSocket

  setup do
    {:ok, socket} =
      connect(LampedusaStraitSocket, %{operator: "Rosaria Matina", console: "MRCC Roma"})

    %{socket: socket}
  end

  test "a first join replays the whole strait log and signs from the connect assigns",
       %{socket: socket} do
    {:ok, reply, talkback} = join(socket, "strait:talkback", %{})

    assert reply.head_seq == 6
    assert reply.signature == "MRCC Roma · Rosaria Matina"
    assert Enum.map(reply.missed, & &1.seq) == [1, 2, 3, 4, 5, 6]
    assert talkback.assigns.acknowledged_seq == 0
  end

  test "a rejoin with last_seq replays only the unacknowledged transmissions", %{socket: socket} do
    {:ok, %{missed: missed}, talkback} = join(socket, "strait:talkback", %{last_seq: 4})

    assert [%{seq: 5, station: "Manta 10-01"}, %{seq: 6, station: "Lampedusa Radio"}] = missed
    assert talkback.assigns.acknowledged_seq == 4

    assert {:ok, %{missed: []}, _caught_up} = join(socket, "strait:talkback", %{last_seq: 6})
  end

  test "acknowledgements must arrive in sequence", %{socket: socket} do
    {:ok, _reply, talkback} = join(socket, "strait:talkback", %{last_seq: 2})

    ref = push(talkback, "acknowledge", %{seq: 4})
    assert_reply ref, :error, %{expected_seq: 3}

    ref = push(talkback, "acknowledge", %{seq: 3})
    assert_reply ref, :ok, %{acknowledged_seq: 3, by: "MRCC Roma · Rosaria Matina"}
  end

  test "a last_seq ahead of the log or not a number is refused", %{socket: socket} do
    assert {:error, %{reason: "last_seq is ahead of the strait log", head_seq: 6}} =
             join(socket, "strait:talkback", %{last_seq: 9})

    assert {:error, %{reason: "last_seq must be a whole sequence number"}} =
             join(socket, "strait:talkback", %{last_seq: "4"})
  end

  test "a console outside the strait cannot connect" do
    assert connect(LampedusaStraitSocket, %{operator: "Rosaria Matina", console: "Malta RCC"}) ==
             :error
  end

  test "the talkback page passes the operator and console to the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/08-lampedusa-strait-talkback")

    assert has_element?(
             view,
             "#strait-talkback[data-operator='Rosaria Matina'][data-console='MRCC Roma']"
           )
  end
end
