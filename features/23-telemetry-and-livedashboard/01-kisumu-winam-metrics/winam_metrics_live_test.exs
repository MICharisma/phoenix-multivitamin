defmodule PhoenixMultivitaminWeb.KisumuWinamMetricsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.KisumuWinamEmitter

  @path "/features/23-telemetry-and-livedashboard/01-kisumu-winam-metrics"
  @handler_id {__MODULE__, :probe}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)
    :ok
  end

  test "the disconnected mount keeps the Winam handler quiet", %{conn: conn} do
    conn = get(conn, @path)
    html = html_response(conn, 200)

    assert html =~ "Kisumu International"
    assert html =~ "Waiting for the socket before attaching"
    refute html =~ "Attached as"
  end

  test "execute delivers measurements to an attached handler and duplicate attach fails", %{
    conn: conn
  } do
    assert :ok =
             :telemetry.attach(
               @handler_id,
               KisumuWinamEmitter.event_name(),
               fn _event, measurements, metadata, test_pid ->
                 send(test_pid, {:probe, measurements, metadata})
               end,
               self()
             )

    assert {:error, :already_exists} =
             :telemetry.attach(
               @handler_id,
               KisumuWinamEmitter.event_name(),
               fn _, _, _, _ -> :ok end,
               %{}
             )

    assert {:ok, 42} =
             KisumuWinamEmitter.cross(%KisumuWinamEmitter{ferry: "MV Mbita", passengers: 42})

    assert_receive {:probe, %{passengers: 42},
                    %{ferry: "MV Mbita", station: "Kisumu International", gulf: "Winam"}}

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#handler-status[data-status=attached]")

    view |> element("#cross-rusinga") |> render_click()
    assert has_element?(view, "#crossing-log", "MV Rusinga")
    assert has_element?(view, "#crossing-log", "28 passengers")

    view |> element("#cross-empty") |> render_click()
    assert render(view) =~ "no passengers to count"
  end

  test "detach removes the handler so later execute is silent" do
    assert :ok =
             :telemetry.attach(
               @handler_id,
               KisumuWinamEmitter.event_name(),
               fn _, measurements, _, test_pid -> send(test_pid, {:heard, measurements}) end,
               self()
             )

    assert :ok = :telemetry.detach(@handler_id)
    assert {:error, :not_found} = :telemetry.detach(@handler_id)

    assert {:ok, 28} =
             KisumuWinamEmitter.cross(%KisumuWinamEmitter{ferry: "MV Rusinga", passengers: 28})

    refute_receive {:heard, _}, 50
  end
end
