defmodule PhoenixMultivitaminWeb.BrestIroiseOrdersTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.BrestIroiseSocket

  setup do
    {:ok, socket} = connect(BrestIroiseSocket, %{"stand" => "4"})
    {:ok, _reply, orders} = subscribe_and_join(socket, "iroise:deice:F-HOPZ", %{})
    %{orders: orders}
  end

  test "an order inside the ceiling replies ok with the numbered order", %{orders: orders} do
    ref = push(orders, "order_fluid", %{"fluid" => "type_iv", "litres" => 380})
    assert_reply ref, :ok, %{order_no: 1, fluid: "type_iv", litres: 380}

    ref = push(orders, "order_fluid", %{"fluid" => "type_i", "litres" => 600})
    assert_reply ref, :ok, %{order_no: 2}
  end

  test "error replies name the field that was refused", %{orders: orders} do
    ref = push(orders, "order_fluid", %{"fluid" => "type_iv", "litres" => 451})
    assert_reply ref, :error, %{litres: "type_iv is capped at 450 L for an ATR 72"}

    ref = push(orders, "order_fluid", %{"fluid" => "type_iv", "litres" => 0})
    assert_reply ref, :error, %{litres: "order at least one litre"}

    ref = push(orders, "order_fluid", %{"fluid" => "type_ii", "litres" => 200})
    assert_reply ref, :error, %{fluid: "Brest stocks type_i and type_iv only"}

    ref = push(orders, "order_fluid", %{"fluid" => "type_i", "litres" => "380"})
    assert_reply ref, :error, %{litres: "send litres as a whole number"}
  end

  test "a bare :ok replies with an empty map, and :noreply sends nothing", %{orders: orders} do
    ref = push(orders, "acknowledge_truck")
    assert_reply ref, :ok, payload
    assert payload == %{}

    ref = push(orders, "truck_position", %{"bay" => "glycol bay B"})
    refute_reply ref, _status
    assert :sys.get_state(orders.channel_pid).assigns.truck_at == "glycol bay B"
  end

  test "close_orders replies with the totals and then stops the channel", %{orders: orders} do
    push(orders, "order_fluid", %{"fluid" => "type_i", "litres" => 600})
    push(orders, "order_fluid", %{"fluid" => "type_iv", "litres" => 380})
    monitor = Process.monitor(orders.channel_pid)

    ref = push(orders, "close_orders")
    assert_reply ref, :ok, %{orders: 2, litres: 980}
    assert_receive {:DOWN, ^monitor, :process, _pid, :normal}
  end

  test "the order desk renders for the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/03-brest-iroise-orders")
    assert has_element?(view, "#iroise-orders[data-registration='F-HOPZ'][data-stand='4']")
  end
end
