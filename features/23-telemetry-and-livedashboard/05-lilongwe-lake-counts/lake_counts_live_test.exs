defmodule PhoenixMultivitaminWeb.LilongweLakeCountsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.LilongweLakeCounts
  alias PhoenixMultivitaminWeb.LilongweLakeReading

  @path "/features/23-telemetry-and-livedashboard/05-lilongwe-lake-counts"
  @handler_id {__MODULE__, :malawi}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)
    :ok
  end

  test "last_value metric watches visibility metres on the Malawi event" do
    [gauge] = LilongweLakeCounts.metrics()

    assert %Telemetry.Metrics.LastValue{} = gauge
    assert gauge.event_name == [:lilongwe, :malawi, :visibility]
    assert gauge.measurement == :metres
    assert gauge.name == [:lilongwe, :malawi, :visibility, :metres]
  end

  test "String.Chars formats a lake reading and emit carries the band" do
    assert {:ok, reading} = LilongweLakeReading.new(8_500, "Lake Malawi")
    assert to_string(reading) =~ "Lake Malawi at Lilongwe International: 8500 m visibility"
    assert LilongweLakeReading.band(reading) == :haze

    :ok =
      :telemetry.attach(
        @handler_id,
        LilongweLakeCounts.event_name(),
        fn _, measurements, metadata, pid -> send(pid, {:malawi, measurements, metadata}) end,
        self()
      )

    assert {:ok, ^reading} = LilongweLakeCounts.report(reading)

    assert_receive {:malawi, %{metres: 8500},
                    %{waterbody: "Lake Malawi", station: "Lilongwe International", band: :haze}}
  end

  test "the board posts visibility and shows the latest gauge", %{conn: conn} do
    :ok =
      :telemetry.attach(
        @handler_id,
        LilongweLakeCounts.event_name(),
        fn _, measurements, metadata, pid -> send(pid, {:board, measurements, metadata}) end,
        self()
      )

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#metric-last_value", "lilongwe.malawi.visibility.metres")
    assert has_element?(view, "#clerk-name", "Chisomo")
    assert has_element?(view, "#craft-name", "ATR 42")

    view
    |> form("#visibility-form", %{metres: "12000"})
    |> render_submit()

    assert_receive {:board, %{metres: 12000.0}, %{band: :clear}}
    assert has_element?(view, "#reading-band", "clear")
    assert has_element?(view, "#reading-metres", "12000")

    view
    |> form("#visibility-form", %{metres: "-3"})
    |> render_submit()

    assert render(view) =~ "zero or greater"
  end
end
