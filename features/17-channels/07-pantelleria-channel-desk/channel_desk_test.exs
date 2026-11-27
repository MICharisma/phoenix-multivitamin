defmodule PhoenixMultivitaminWeb.PantelleriaChannelDeskTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.PantelleriaDeskSocket

  defp join_desk(cadence_ms) do
    {:ok, socket} = connect(PantelleriaDeskSocket, %{})
    join(socket, "pantelleria:anemometers", %{cadence_ms: cadence_ms})
  end

  test "the join reply comes first, then the wind table, then samples on the cadence" do
    assert {:ok, %{cadence_ms: 10}, _desk} = join_desk(10)

    assert_push "wind_table", %{runway: "08/26", sensors: [_, _, _], shear_kt: 15}
    assert_push "anemometer", %{sensor: "RWY 08 threshold", headwind_kt: 18}
    assert_push "anemometer", %{sensor: "Montagna Grande ridge", headwind_kt: 22}
    assert_push "anemometer", %{sensor: "RWY 26 threshold", headwind_kt: 4}
    assert_push "windshear_alert", %{sensor: "RWY 26 threshold", change_kt: -18}
    assert_push "windshear_alert", %{sensor: "RWY 08 threshold", change_kt: 17}
  end

  test "the join payload cadence is clamped" do
    assert {:ok, %{cadence_ms: 10}, _desk} = join_desk(1)
    assert {:ok, %{cadence_ms: 10_000}, _desk} = join_desk(600_000)
  end

  test "pausing drops the pending tick and resuming starts a fresh one" do
    {:ok, _reply, desk} = join_desk(40)
    assert_push "anemometer", %{headwind_kt: 18}

    ref = push(desk, "pause_sampling")
    assert_reply ref, :ok, %{sensor_paused: "RWY 08 threshold"}
    refute_push "anemometer", _sample, 120

    ref = push(desk, "resume_sampling")
    assert_reply ref, :ok
    assert_push "anemometer", %{sensor: "Montagna Grande ridge"}
  end

  test "the desk page hands the cadence to the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/07-pantelleria-channel-desk")
    assert has_element?(view, "#pantelleria-desk[data-cadence-ms='1500'] polyline[data-trace]")
  end
end
