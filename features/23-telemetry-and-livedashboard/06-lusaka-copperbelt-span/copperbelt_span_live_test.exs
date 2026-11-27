defmodule PhoenixMultivitaminWeb.LusakaCopperbeltSpanLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.LusakaCopperbeltSpan

  @path "/features/23-telemetry-and-livedashboard/06-lusaka-copperbelt-span"
  @handler_id {__MODULE__, :copperbelt}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)

    :ok =
      :telemetry.attach_many(
        @handler_id,
        [
          LusakaCopperbeltSpan.start_event(),
          LusakaCopperbeltSpan.stop_event(),
          LusakaCopperbeltSpan.exception_event()
        ],
        fn event, measurements, metadata, test_pid ->
          send(test_pid, {:span, List.last(event), measurements, metadata})
        end,
        self()
      )

    :ok
  end

  test "a stable load emits start then stop with a shared span context" do
    result = LusakaCopperbeltSpan.load("copper cathode", 28)

    assert result.status == :stowed
    assert result.tonnes == 28

    assert_receive {:span, :start, start_measurements, start_meta}
    assert start_measurements.system_time
    assert start_meta.apron == "Lusaka International"
    assert start_meta.belt == "Copperbelt"
    context = start_meta.telemetry_span_context

    assert_receive {:span, :stop, stop_measurements, stop_meta}
    assert stop_measurements.duration >= 0
    assert stop_meta.telemetry_span_context == context
    assert stop_meta.cargo == "copper cathode"
    refute_receive {:span, :exception, _, _}
  end

  test "an unstable load emits start then exception with kind, reason, and stacktrace" do
    assert {:error, {:load_failed, reason}} =
             LusakaCopperbeltSpan.load("uncrated concentrate", 12)

    assert reason =~ "unstable Copperbelt cargo"

    assert_receive {:span, :start, _start_measurements, start_meta}
    context = start_meta.telemetry_span_context

    assert_receive {:span, :exception, exception_measurements, exception_meta}
    assert exception_measurements.duration >= 0
    assert exception_meta.telemetry_span_context == context
    assert exception_meta.kind == :error
    assert match?(%ArgumentError{}, exception_meta.reason)
    assert is_list(exception_meta.stacktrace)
    refute_receive {:span, :stop, _, _}
  end

  test "the LiveView board shows exception metadata after a refused load", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Lusaka International"
    assert has_element?(view, "#listening-flag", "Listening for start, stop, and exception")
    assert has_element?(view, "#clerk-name", "Mutale")
    assert has_element?(view, "#craft-name", "IL-76")

    view |> element("#stow-cathode") |> render_click()
    assert has_element?(view, "#span-log", "start")
    assert has_element?(view, "#span-log", "stop")
    assert has_element?(view, "#result-stowed", "copper cathode")

    view |> element("#stow-uncrated") |> render_click()
    assert has_element?(view, "#span-log", "exception")
    assert has_element?(view, "#span-log", "stacktrace present")
    assert render(view) =~ "unstable Copperbelt cargo"
  end
end
