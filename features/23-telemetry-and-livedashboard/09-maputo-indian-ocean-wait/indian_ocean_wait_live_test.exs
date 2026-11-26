defmodule PhoenixMultivitaminWeb.MaputoIndianOceanWaitLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/23-telemetry-and-livedashboard/09-maputo-indian-ocean-wait"
  @handler_id {__MODULE__, :maputo_http_probe}

  @events [
    [:phoenix, :endpoint, :start],
    [:phoenix, :endpoint, :stop],
    [:phoenix, :router_dispatch, :start],
    [:phoenix, :router_dispatch, :stop]
  ]

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)

    :ok =
      :telemetry.attach_many(
        @handler_id,
        @events,
        fn event, measurements, metadata, test_pid ->
          send(test_pid, {:http_probe, event, measurements, metadata})
        end,
        self()
      )

    :ok
  end

  test "HTTP get fires endpoint start/stop and router_dispatch start/stop", %{conn: conn} do
    conn = get(conn, @path)
    assert html_response(conn, 200) =~ "Maputo"

    assert_receive {:http_probe, [:phoenix, :endpoint, :start], start_m, _meta}
    assert Map.has_key?(start_m, :system_time)

    assert_receive {:http_probe, [:phoenix, :router_dispatch, :start], _m, router_start}
    assert is_binary(router_start[:route]) or is_atom(router_start[:plug])

    assert_receive {:http_probe, [:phoenix, :router_dispatch, :stop], router_stop_m, _}
    assert router_stop_m.duration > 0

    assert_receive {:http_probe, [:phoenix, :endpoint, :stop], endpoint_stop_m, _}
    assert endpoint_stop_m.duration > 0
  end

  test "the LiveView catalogues built-in events and accepts a stand mark", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Indian Ocean"
    assert has_element?(view, "#clerk-name", "Anchia")
    assert has_element?(view, "#craft-name", "Dash 8 Q400")
    assert has_element?(view, "#event-phoenix-endpoint-start")
    assert has_element?(view, "#event-phoenix-endpoint-stop")
    assert has_element?(view, "#event-phoenix-router_dispatch-start")
    assert has_element?(view, "#event-phoenix-router_dispatch-stop")
    assert has_element?(view, "#listening-flag", "Attached to endpoint and router_dispatch")

    view |> element("#mark-stand-4") |> render_click()
    assert has_element?(view, "#probe-log", "Stand 4")

    view |> element("#mark-empty-stand") |> render_click()
    assert render(view) =~ "needs a stand"
  end
end
