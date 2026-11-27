defmodule PhoenixMultivitaminWeb.ConstantaBlackSeaWireTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.{ConstantaBlackSeaChannel, ConstantaBlackSeaSocket}

  @yr_bsa 0x4A0F3C

  setup do
    {:ok, socket} = connect(ConstantaBlackSeaSocket, %{})
    %{wire: subscribe_and_join!(socket, "black_sea:tracks")}
  end

  test "a binary frame is decoded, broadcast as a map, and acknowledged in binary", %{wire: wire} do
    ref =
      push(wire, "frame", {:binary, ConstantaBlackSeaChannel.pack_frame(@yr_bsa, 1500, 112, 620)})

    assert_reply ref, :ok, {:binary, <<1::32, 0::8>>}
    assert_broadcast "track", %{icao: "4A0F3C", altitude_ft: 1500, heading: 112, low_fuel: false}

    ref =
      push(wire, "frame", {:binary, ConstantaBlackSeaChannel.pack_frame(@yr_bsa, 900, 287, 380)})

    assert_reply ref, :ok, {:binary, <<2::32, 1::8>>}
    assert_push "track", %{fuel_kg: 380, low_fuel: true}
  end

  test "clause order names what is wrong with a frame", %{wire: wire} do
    ref =
      push(wire, "frame", {:binary, ConstantaBlackSeaChannel.pack_frame(@yr_bsa, 1500, 400, 620)})

    assert_reply ref, :error, %{reason: "heading 400 is not a compass heading"}

    ref = push(wire, "frame", {:binary, <<0x4A, 0x0F, 0x3C, 5, 220>>})
    assert_reply ref, :error, %{reason: "frames are 9 bytes", bytes: 5}

    ref = push(wire, "frame", %{icao: "4A0F3C", altitude_ft: 1500})
    assert_reply ref, :error, %{reason: "send tracker frames as binary"}

    refute_broadcast "track", _track
  end

  test "the platform table is packed by a binary comprehension", %{wire: wire} do
    ref = push(wire, "platform_depths")
    assert_reply ref, :ok, {:binary, <<3, 70::16, 82::16, 48::16>>}
  end

  test "the wire form carries the tracker's ICAO address" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/11-constanta-black-sea-wire")
    assert has_element?(view, "#black-sea-wire[data-icao='4A0F3C'] input[name='heading']")
  end
end
