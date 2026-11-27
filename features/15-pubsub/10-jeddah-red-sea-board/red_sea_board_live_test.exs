defmodule PhoenixMultivitaminWeb.JeddahRedSeaBoardLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/10-jeddah-red-sea-board"
  @topic "jeddah:red-sea-gates"

  test "a gate move sends only the flight and gate, and both boards follow", %{conn: conn} do
    {:ok, gate_desk, _html} = live(conn, @path)
    {:ok, transfer_desk, _html} = live(build_conn(), @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    gate_desk |> form("#gate-form", flight: "SV1458", gate: "d07") |> render_submit()

    assert_receive {:gate_moved, "SV1458", "D7"}
    assert has_element?(transfer_desk, "#flight-SV1458 .gate", "D7")
    assert has_element?(transfer_desk, "#flight-SV1021 .gate", "A12")
    assert has_element?(gate_desk, "#flight-SV1458", "240 seats")
  end

  test "the slim payload is a small fraction of the whole flight", %{conn: conn} do
    {:ok, gate_desk, _html} = live(conn, @path)

    gate_desk |> form("#gate-form", flight: "XY204", gate: "B30") |> render_submit()

    manifest = for row <- 1..40, seat <- ~w(A B C D E F), do: "#{row}#{seat}"
    whole_flight = %{number: "XY204", destination: "Cairo", gate: "B30", manifest: manifest}
    slim = :erlang.external_size({:gate_moved, "XY204", "B30"})
    full = :erlang.external_size({:flight_changed, whole_flight})

    assert has_element?(gate_desk, "#slim-bytes", "#{slim} bytes")
    assert has_element?(gate_desk, "#full-bytes", "#{full} bytes")
    assert full > 40 * slim
  end

  test "gates outside A1–D40 and unknown flights are not broadcast", %{conn: conn} do
    {:ok, gate_desk, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    for {flight, gate} <- [{"SV1021", "E4"}, {"SV1021", "A41"}, {"SV1021", ""}, {"MS642", "A2"}] do
      render_submit(gate_desk, "move_gate", %{"flight" => flight, "gate" => gate})
      assert has_element?(gate_desk, "#flash-error", "Red Sea gate")
    end

    refute_received {:gate_moved, _flight, _gate}
    refute has_element?(gate_desk, "#payload-sizes")
  end
end
