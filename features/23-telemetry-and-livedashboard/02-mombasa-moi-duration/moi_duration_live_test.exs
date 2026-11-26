defmodule PhoenixMultivitaminWeb.MombasaMoiDurationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MombasaMoiTurnaround

  @path "/features/23-telemetry-and-livedashboard/02-mombasa-moi-duration"
  @handler_id {__MODULE__, :moi}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)

    :ok =
      :telemetry.attach_many(
        @handler_id,
        [MombasaMoiTurnaround.start_event(), MombasaMoiTurnaround.stop_event()],
        fn event, measurements, metadata, test_pid ->
          send(test_pid, {:span, List.last(event), measurements, metadata})
        end,
        self()
      )

    :ok
  end

  test "span emits start then stop with a shared telemetry_span_context" do
    result = MombasaMoiTurnaround.run("Stand 12", 45)

    assert result.status == :cleared
    assert result.minutes == 45

    assert_receive {:span, :start, start_measurements, start_meta}
    assert start_measurements.system_time
    assert start_meta.stand == "Stand 12"
    assert start_meta.airport == "Moi International"
    context = start_meta.telemetry_span_context

    assert_receive {:span, :stop, stop_measurements, stop_meta}
    assert stop_measurements.duration > 0
    assert stop_meta.telemetry_span_context == context
    assert stop_meta.apron == "Terminal 1"
    refute_receive {:span, :exception, _, _}
  end

  test "the LiveView board lists start and stop after a clearance", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Moi International"
    assert has_element?(view, "#listening-flag", "Listening for start and stop")

    view |> element("#clear-stand-12") |> render_click()
    assert has_element?(view, "#span-log", "start")
    assert has_element?(view, "#span-log", "stop")
    assert has_element?(view, "#span-log", "Stand 12")
    assert has_element?(view, "#span-log", "context present")

    view |> element("#clear-stand-bad") |> render_click()
    assert render(view) =~ "must be positive"
  end
end
