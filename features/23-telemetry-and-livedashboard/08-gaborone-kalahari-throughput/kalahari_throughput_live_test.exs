defmodule PhoenixMultivitaminWeb.GaboroneKalahariThroughputLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.GaboroneKalahariThroughput

  @path "/features/23-telemetry-and-livedashboard/08-gaborone-kalahari-throughput"
  @handler_id {__MODULE__, :kalahari_probe}
  @poller_name :gaborone_kalahari_test_poller

  setup do
    {:ok, _} = GaboroneKalahariThroughput.start_counter()
    Agent.update(GaboroneKalahariThroughput.agent_name(), fn _ -> 0 end)

    on_exit(fn ->
      :telemetry.detach(@handler_id)

      case Process.whereis(@poller_name) do
        nil -> :ok
        pid -> GenServer.stop(pid, :normal)
      end
    end)

    :ok
  end

  test "last_value metric points at the apron_count event" do
    [metric] = GaboroneKalahariThroughput.metrics()

    assert %Telemetry.Metrics.LastValue{} = metric
    assert metric.event_name == [:gaborone, :kalahari, :apron_count]
    assert metric.measurement == :aircraft
    assert metric.name == [:gaborone, :kalahari, :apron_count, :aircraft]
  end

  test "telemetry_poller periodically invokes measure_apron and the board parks a CRJ", %{
    conn: conn
  } do
    assert :ok =
             :telemetry.attach(
               @handler_id,
               GaboroneKalahariThroughput.event_name(),
               fn _event, measurements, metadata, test_pid ->
                 send(test_pid, {:apron, measurements, metadata})
               end,
               self()
             )

    _poller =
      start_supervised!(
        {:telemetry_poller,
         measurements: [{GaboroneKalahariThroughput, :measure_apron, []}],
         period: 50,
         name: @poller_name}
      )

    assert_receive {:apron, %{aircraft: 0}, %{apron: "Kalahari", station: station}}, 500
    assert station =~ "Gaborone"

    GaboroneKalahariThroughput.park_aircraft()
    assert_receive {:apron, %{aircraft: 1}, _meta}, 500

    {:ok, view, html} = live(conn, @path)
    assert html =~ "Kalahari"
    assert has_element?(view, "#metric-name", "gaborone.kalahari.apron_count.aircraft")
    assert has_element?(view, "#clerk-name", "Keabetswe")
    assert has_element?(view, "#craft-name", "CRJ-900")

    view |> element("#park-crj") |> render_click()
    assert has_element?(view, "#apron-count", "Aircraft on apron:")
    assert has_element?(view, "#sample-log", "manual")

    view |> element("#refuse-ghost") |> render_click()
    assert render(view) =~ "ghost CRJ-900"
  end
end
