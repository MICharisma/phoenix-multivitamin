defmodule PhoenixMultivitaminWeb.AlderneyCasquetsWireTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.AlderneyCasquetsSocket

  @path "/features/17-channels/01-alderney-casquets-wire"

  test "a current shift token connects, names the desk socket, and joins the wire" do
    shift_token = AlderneyCasquetsSocket.sign_shift("Morwenna Le Page", "north")

    assert {:ok, socket} = connect(AlderneyCasquetsSocket, %{"shift_token" => shift_token})
    assert socket.id == "casquets_desk:north"
    assert socket.assigns.dispatcher == "Morwenna Le Page"

    assert {:ok, %{desk: "north", reading: %{wind: "250/28G38KT"}}, _socket} =
             subscribe_and_join(socket, "casquets:wire", %{})
  end

  test "an expired shift and a forged shift are refused with a reason" do
    nine_hours_ago = System.system_time(:second) - 9 * 60 * 60

    expired =
      AlderneyCasquetsSocket.sign_shift("Morwenna Le Page", "north", signed_at: nine_hours_ago)

    assert connect(AlderneyCasquetsSocket, %{"shift_token" => expired}) ==
             {:error, %{reason: "expired"}}

    assert connect(AlderneyCasquetsSocket, %{"shift_token" => "SFMyNTY.forged.casquets"}) ==
             {:error, %{reason: "invalid"}}
  end

  test "a socket without a shift token is refused outright" do
    assert connect(AlderneyCasquetsSocket, %{"dispatcher" => "Morwenna Le Page"}) == :error
  end

  test "signing off broadcasts disconnect to the desk id and clears the token" do
    PhoenixMultivitaminWeb.Endpoint.subscribe("casquets_desk:north")
    {:ok, view, _html} = live(build_conn(), @path)

    assert has_element?(view, "#casquets-wire[phx-hook$='.CasquetsWire'][data-shift-token]")
    view |> element("#sign-off-desk") |> render_click()

    assert_receive %Phoenix.Socket.Broadcast{topic: "casquets_desk:north", event: "disconnect"}
    assert has_element?(view, "#casquets-wire[data-shift-token='']")
    assert has_element?(view, "#sign-off-desk[disabled]")
  end
end
