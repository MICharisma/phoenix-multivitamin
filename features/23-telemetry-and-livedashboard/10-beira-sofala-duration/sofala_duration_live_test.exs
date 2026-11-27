defmodule PhoenixMultivitaminWeb.BeiraSofalaDurationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.BeiraSofalaDuration

  @path "/features/23-telemetry-and-livedashboard/10-beira-sofala-duration"
  @handler_id {__MODULE__, :sofala_query}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)

    :ok =
      :telemetry.attach(
        @handler_id,
        BeiraSofalaDuration.event_name(),
        fn _event, measurements, metadata, test_pid ->
          send(test_pid, {:repo_query, measurements, metadata})
        end,
        self()
      )

    :ok
  end

  test "run_ping returns the SELECT 1 row and emits repo query measurements" do
    assert {:ok, ping} = BeiraSofalaDuration.run_ping()
    assert ping.column == "sofala_ping"
    assert ping.value == 1
    assert ping.harbour == "Beira"
    assert ping.province == "Sofala"

    assert_receive {:repo_query, measurements, _metadata}
    assert is_integer(measurements.total_time)
    assert measurements.total_time >= 0
    assert Map.has_key?(measurements, :query_time)
  end

  test "the LiveView board logs a Sofala ping", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Beira"
    assert has_element?(view, "#clerk-name", "Esperança")
    assert has_element?(view, "#craft-name", "An-26")

    view |> element("#ping-sofala") |> render_click()

    assert_receive {:repo_query, %{total_time: total_time}, _}
    assert is_integer(total_time)

    assert has_element?(view, "#ping-total", "1")
    assert has_element?(view, "#ping-log", "sofala_ping=1")
    assert has_element?(view, "#ping-log", "Beira/Sofala")

    view |> element("#discard-pings") |> render_click()
    assert has_element?(view, "#ping-total", "0")
    assert has_element?(view, "#empty-pings")
  end
end
