defmodule PhoenixMultivitaminWeb.ToamasinaVanillaGaugeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/23-telemetry-and-livedashboard/11-toamasina-vanilla-gauge"
  @handler_id {__MODULE__, :vanilla_spans}

  @events [
    [:phoenix, :live_view, :mount, :start],
    [:phoenix, :live_view, :mount, :stop],
    [:phoenix, :live_view, :handle_event, :start],
    [:phoenix, :live_view, :handle_event, :stop]
  ]

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)

    :ok =
      :telemetry.attach_many(
        @handler_id,
        @events,
        fn event, measurements, metadata, test_pid ->
          send(test_pid, {:lv_span, event, measurements, metadata})
        end,
        self()
      )

    :ok
  end

  test "mount fires as start/stop spans (disconnected + connected may both run)", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Toamasina"
    assert has_element?(view, "#clerk-name", "Fara")
    assert has_element?(view, "#craft-name", "Twin Otter")

    mount_starts = receive_mount_starts([])
    mount_count = length(mount_starts)

    # Confirmed: live/2 triggers disconnected mount then connected mount (2 starts).
    assert mount_count == 2

    assert_receive {:lv_span, [:phoenix, :live_view, :mount, :stop], stop_m, stop_meta}
    assert stop_m.duration >= 0
    assert stop_meta.socket.view == PhoenixMultivitaminWeb.ToamasinaVanillaGaugeLive

    view |> element("#log-sambava") |> render_click()

    assert_receive {:lv_span, [:phoenix, :live_view, :handle_event, :start], start_m, start_meta}
    assert Map.has_key?(start_m, :system_time)
    assert start_meta.event == "log_vanilla_crate"

    assert_receive {:lv_span, [:phoenix, :live_view, :handle_event, :stop], event_stop_m,
                    event_stop_meta}

    assert event_stop_m.duration >= 0
    assert event_stop_meta.event == "log_vanilla_crate"

    assert has_element?(view, "#crate-count", "1")
    assert has_element?(view, "#crate-log", "Sambava A")
    assert has_element?(view, "#crate-Sambava-A", "12.5 kg")

    view |> element("#log-empty-lot") |> render_click()
    assert render(view) =~ "needs a vanilla lot"
  end

  defp receive_mount_starts(acc) do
    receive do
      {:lv_span, [:phoenix, :live_view, :mount, :start], measurements, metadata} ->
        receive_mount_starts([{measurements, metadata} | acc])
    after
      100 -> Enum.reverse(acc)
    end
  end
end
