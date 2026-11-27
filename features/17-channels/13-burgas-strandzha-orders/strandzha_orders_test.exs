defmodule PhoenixMultivitaminWeb.BurgasStrandzhaOrdersTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Plug.Conn, except: [push: 3]
  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.BurgasStrandzhaSocket

  @path "/features/17-channels/13-burgas-strandzha-orders"
  @longpoll "/features/17-channels/13-burgas-strandzha-orders/socket/longpoll"
  @endpoint PhoenixMultivitaminWeb.Endpoint

  defp join_role(role, callsign, shift \\ "afternoon") do
    token = BurgasStrandzhaSocket.sign_watch(role, callsign)

    assert {:ok, socket} =
             connect(BurgasStrandzhaSocket, %{},
               connect_info: %{auth_token: token, user_agent: "StrandzhaConsole/1.0"}
             )

    assert socket.assigns.role == role
    assert socket.assigns.user_agent == "StrandzhaConsole/1.0"

    assert {:ok, reply, drops} =
             subscribe_and_join(socket, "strandzha:drops", %{shift: shift})

    _ = :sys.get_state(drops.channel_pid)
    {socket, reply, drops}
  end

  test "auth_token from connect_info signs the watch; params alone are refused" do
    assert connect(BurgasStrandzhaSocket, %{"role" => "tower"}, connect_info: %{}) ==
             {:error, %{reason: "auth_token required"}}

    expired =
      BurgasStrandzhaSocket.sign_watch("tower", "Burgas Tower",
        signed_at: System.system_time(:second) - 13 * 60 * 60
      )

    assert connect(BurgasStrandzhaSocket, %{}, connect_info: %{auth_token: expired}) ==
             {:error, %{reason: "expired"}}
  end

  test "the tower socket is named; a second client sees the join and a redacted lookout order" do
    {tower_socket, tower_reply, tower} =
      join_role("tower", "Burgas Tower · Nadezhda Ivanova")

    assert tower_socket.id == "strandzha_tower:Burgas Tower · Nadezhda Ivanova"

    assert MapSet.new(tower_reply.landing_zones) ==
             MapSet.new(["Sinemorets ridge", "Malko Tarnovo spur", "Strandzha peak"])

    {_heli_socket, _heli_reply, helicopter} = join_role("helicopter", "Mi-17 CU-17 Strandzha")
    assert_push "net_join", %{role: "helicopter", callsign: "Mi-17 CU-17 Strandzha"}

    {_lookout_socket, _lookout_reply, lookout} = join_role("lookout", "Malko Tarnovo lookout")

    ref =
      push(tower, "order_drop", %{
        landing_zone: "Sinemorets ridge",
        loads: 2,
        fuel_state: "45 minutes",
        radio_discrete: "122.450"
      })

    assert_reply ref, :ok, %{order_no: 1, grid: "SN-14"}
    assert_broadcast "drop_order", %{radio_discrete: "122.450", water_source: "Veleka mouth"}

    # Each subscribed channel process pushes its own intercepted copy.
    assert_push "drop_order", %{
      radio_discrete: "122.450",
      ordered_by: "Burgas Tower · Nadezhda Ivanova"
    }

    assert_push "drop_order", %{radio_discrete: "122.450"}
    assert_push "drop_order", order when not is_map_key(order, :radio_discrete)

    ref = push(helicopter, "accept_drop", %{order_no: 1})
    refute_reply ref, _status
    assert_push "drop_accepted", %{order_no: 1, by: "Mi-17 CU-17 Strandzha"}
    assert_push "drop_accepted", %{order_no: 1}

    ref = push(lookout, "order_drop", %{landing_zone: "Strandzha peak"})
    assert_reply ref, :error, %{reason: "only Burgas Tower orders Strandzha drops"}
  end

  test "longpoll answers status 410 with a session token when the auth token is good" do
    token = BurgasStrandzhaSocket.sign_watch("tower", "Burgas Tower · Nadezhda Ivanova")

    conn =
      build_conn()
      |> put_req_header("x-phoenix-authtoken", token)
      |> put_req_header("user-agent", "StrandzhaLongPoll/1.0")
      |> get(@longpoll)

    # LongPoll always sends HTTP 200; the transport status lives in the JSON body.
    assert %{"status" => 410, "token" => session_token} = json_response(conn, 200)
    assert is_binary(session_token)

    refused =
      build_conn()
      |> put_req_header("x-phoenix-authtoken", "forged.watch")
      |> get(@longpoll)

    assert %{"status" => 403} = json_response(refused, 200)
  end

  test "the orders board exposes watches and both transports for the JS client" do
    {:ok, view, html} = live(build_conn(), @path)

    assert has_element?(view, "#strandzha-orders option[value='longpoll']")
    assert has_element?(view, "#strandzha-orders option[value='helicopter']")
    assert html =~ "data-watches"
    assert has_element?(view, "#clear-tower")
  end
end
