defmodule PhoenixMultivitaminWeb.PembaCloveCountersLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.PembaCloveCounters

  @path "/features/23-telemetry-and-livedashboard/03-pemba-clove-counters"
  @handler_id {__MODULE__, :clove}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)
    :ok
  end

  test "counter and sum metrics share one event name with different measurement strategies" do
    [counter, sum] = PembaCloveCounters.metrics()

    assert %Telemetry.Metrics.Counter{} = counter
    assert counter.event_name == [:pemba, :clove, :sack_weighed]
    assert counter.name == [:pemba, :clove, :sack_weighed, :count]

    assert %Telemetry.Metrics.Sum{} = sum
    assert sum.measurement == :kilograms
    assert sum.event_name == counter.event_name
  end

  test "weighing sacks accumulates board totals and fires the clove event", %{conn: conn} do
    :ok =
      :telemetry.attach(
        @handler_id,
        PembaCloveCounters.event_name(),
        fn _, measurements, metadata, pid -> send(pid, {:clove, measurements, metadata}) end,
        self()
      )

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#metric-counter", "pemba.clove.sack_weighed.count")
    assert has_element?(view, "#metric-sum", "pemba.clove.sack_weighed.kilograms")

    view
    |> form("#weigh-form", %{lot: "Kitogani A", kilograms: "18.5"})
    |> render_submit()

    assert_receive {:clove, %{kilograms: 18.5}, %{lot: "Kitogani A", island: "Pemba"}}
    assert has_element?(view, "#sack-count", "1")
    assert has_element?(view, "#kilogram-total", "18.5")

    view
    |> form("#weigh-form", %{lot: "Wete B", kilograms: "0"})
    |> render_submit()

    assert render(view) =~ "positive weight"
  end
end
