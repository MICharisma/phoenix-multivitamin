defmodule PhoenixMultivitaminWeb.OhridLakeTalkTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.{OhridLakeChannel, OhridLakeSocket, OhridTowerChannel}

  setup do
    {:ok, socket} = connect(OhridLakeSocket, %{callsign: "Ohrid Tower"})
    %{socket: socket}
  end

  test "the splat routes runway, apron, and approach topics to the lake channel", %{
    socket: socket
  } do
    assert {:ok, %{kind: "runway", name: "Runway 20"}, runway} = join(socket, "ohrid:runway:20")
    assert runway.channel == OhridLakeChannel

    assert {:ok, %{name: "Stand 4", frequency: "121.850"}, _apron} = join(socket, "ohrid:apron:4")

    assert {:ok, %{name: "Approach over Galicica"}, _approach} =
             join(socket, "ohrid:approach:galicica")
  end

  test "the exact tower line above the splat wins", %{socket: socket} do
    assert {:ok, %{sectors: [_ | _]}, tower} = join(socket, "ohrid:tower")
    assert tower.channel == OhridTowerChannel
  end

  test "unknown segments are refused by the lake channel", %{socket: socket} do
    assert {:error, %{reason: "Ohrid has stands 1 to 6"}} = join(socket, "ohrid:apron:9")
    assert {:error, %{reason: "Ohrid has stands 1 to 6"}} = join(socket, "ohrid:apron:north")
    assert {:error, %{reason: "no such sector at Ohrid"}} = join(socket, "ohrid:runway:02:left")
    assert {:error, %{reason: "no such sector at Ohrid"}} = join(socket, "ohrid:runway:08")
  end

  test "the splat also matches the bare prefix with nothing after the colon", %{socket: socket} do
    assert {:error, %{reason: "name a sector after ohrid:"}} = join(socket, "ohrid:")
  end

  test "a topic with no channel line never reaches a join", %{socket: socket} do
    assert_raise RuntimeError, ~r/no channel found for topic "struga:apron:1"/, fn ->
      join(socket, "struga:apron:1")
    end

    assert_raise RuntimeError, ~r/no channel found for topic "ohrid"/, fn ->
      join(socket, "ohrid")
    end
  end

  test "the tower closes a sector by broadcasting into that sector's topic", %{socket: socket} do
    {:ok, _sector, lake} = subscribe_and_join(socket, "ohrid:approach:lake")
    {:ok, _roster, tower} = join(socket, "ohrid:tower")

    ref = push(tower, "close_sector", %{sector: "ohrid:approach:lake"})
    assert_reply ref, :ok
    assert_broadcast "sector_closed", %{sector: "ohrid:approach:lake", by: "Ohrid Tower"}
    assert_push "sector_closed", %{by: "Ohrid Tower"}

    ref = push(tower, "close_sector", %{sector: "ohrid:apron:6"})
    assert_reply ref, :error, %{reason: "ohrid:apron:6 is not a sector the tower can close"}

    push(lake, "talk", %{words: "HA-LVA, wind 200 at 6, cleared to land runway 20"})
    assert_push "talk", %{callsign: "Ohrid Tower"}
  end

  test "the speaker panel lists every sector topic" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/10-ohrid-lake-talk")
    assert has_element?(view, "#ohrid-lake-talk input[value='ohrid:approach:lake']")
    assert has_element?(view, "#ohrid-lake-talk input[value='struga:apron:1']")
  end
end
