defmodule PhoenixMultivitaminWeb.MayotteLagoonMetricsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MayotteLagoonMetrics
  alias PhoenixMultivitaminWeb.Telemetry

  @path "/features/23-telemetry-and-livedashboard/13-mayotte-lagoon-metrics"
  @handler_id {__MODULE__, :mayotte}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)
    :ok
  end

  test "dashboard metrics cover counter, sum, last_value, summary, and distribution" do
    kinds = MayotteLagoonMetrics.metric_kinds()

    assert :counter in kinds
    assert :sum in kinds
    assert :last_value in kinds
    assert :summary in kinds
    assert :distribution in kinds

    names =
      Telemetry.metrics()
      |> Enum.map(&Enum.join(&1.name, "."))

    assert "mayotte.lagoon.ferry_crossing.count" in names
    assert "mayotte.lagoon.depth_metres.depth" in names
  end

  test "attached test handlers receive lagoon events on the board", %{conn: conn} do
    :ok =
      :telemetry.attach_many(
        @handler_id,
        [
          MayotteLagoonMetrics.crossing_event(),
          MayotteLagoonMetrics.depth_event(),
          MayotteLagoonMetrics.clearance_event()
        ],
        fn event, measurements, metadata, pid ->
          send(pid, {:probe, List.last(event), measurements, metadata})
        end,
        self()
      )

    assert {:ok, 36} = MayotteLagoonMetrics.cross_ferry("Barbatura", 36)
    assert_receive {:probe, :ferry_crossing, %{passengers: 36}, %{ferry: "Barbatura"}}

    assert {:ok, 14.2} = MayotteLagoonMetrics.sound_depth(14.2)
    assert_receive {:probe, :depth_metres, %{depth: 14.2}, %{lagoon: "Mayotte"}}

    assert {:ok, %{quay: "Quay Mangrove"}} = MayotteLagoonMetrics.clear_slot("Quay Mangrove", 12)

    assert_receive {:probe, :slot_clearance, %{duration: duration}, %{quay: "Quay Mangrove"}}
    assert duration > 0

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#kinds-list", "counter")
    assert has_element?(view, "#listening-flag", "Lagoon handlers attached")

    view |> element("#cross-ferry") |> render_click()
    assert has_element?(view, "#lagoon-log", "Barbatura")

    view |> form("#depth-form", %{metres: "11.0"}) |> render_submit()
    assert has_element?(view, "#current-depth", "11.0")

    view |> element("#clear-slot") |> render_click()
    assert has_element?(view, "#lagoon-log", "Quay Mangrove")
  end
end
