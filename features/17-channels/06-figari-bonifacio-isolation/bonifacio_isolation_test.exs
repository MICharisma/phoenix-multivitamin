defmodule PhoenixMultivitaminWeb.FigariBonifacioIsolationTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias Phoenix.Socket.Message
  alias PhoenixMultivitaminWeb.FigariBonifacioSocket

  setup do
    [marshal, fuel_truck] =
      for unit <- ["marshal", "fuel_truck"] do
        {:ok, socket} = connect(FigariBonifacioSocket, %{"unit" => unit})
        {:ok, _reply, apron} = subscribe_and_join(socket, "figari:apron")
        apron
      end

    %{marshal: marshal, fuel_truck: fuel_truck}
  end

  test "the sender gets a reply and a checklist push; the others get broadcast_from",
       %{marshal: marshal} do
    ref = push(marshal, "isolate_stand", %{"stand" => "4", "hazard" => "fuel_spill"})

    assert_reply ref, :ok, %{isolation_ref: "FSC-ISO-4-marshal"}

    marshal_join_ref = marshal.join_ref

    assert_receive %Message{
      event: "isolation_checklist",
      join_ref: ^marshal_join_ref,
      payload: %{steps: [_, _, _]}
    }

    assert_broadcast "stand_isolated", %{stand: "4", by: "marshal"}
    assert_push "stand_isolated", %{hazard: "fuel_spill"}
    refute_push "stand_isolated", _second_copy_for_the_sender
  end

  test "broadcast! reaches the sender too", %{fuel_truck: fuel_truck} do
    ref = push(fuel_truck, "lift_isolation", %{"stand" => "4"})

    assert_push "isolation_lifted", %{stand: "4", by: "fuel_truck"}
    assert_push "isolation_lifted", %{stand: "4", by: "fuel_truck"}
    refute_reply ref, _status
  end

  test "an unknown hazard is refused without pushing or broadcasting", %{fuel_truck: fuel_truck} do
    ref = push(fuel_truck, "isolate_stand", %{"stand" => "2", "hazard" => "volcanic_ash"})

    assert_reply ref, :error, %{reason: "no isolation procedure for volcanic_ash"}
    refute_broadcast "stand_isolated", _notice
    refute_push "isolation_checklist", _steps
  end

  test "connect/2 refuses a unit that does not work the apron" do
    assert connect(FigariBonifacioSocket, %{"unit" => "catering"}) == :error
  end

  test "the apron board renders stand buttons for the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/06-figari-bonifacio-isolation")

    assert has_element?(
             view,
             "#bonifacio-isolation button[data-isolate='5'][data-hazard='fuel_spill']"
           )
  end
end
