defmodule PhoenixMultivitaminWeb.KilimanjaroKiboCycleLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.KilimanjaroKiboCycle

  @path "/features/23-telemetry-and-livedashboard/04-kilimanjaro-kibo-cycle"
  @handler_id {__MODULE__, :kibo_probe}
  @fragile_id {__MODULE__, :fragile_kibo}

  setup do
    on_exit(fn ->
      _ = :telemetry.detach(@handler_id)
      _ = :telemetry.detach(@fragile_id)
    end)

    :ok
  end

  test "attach_many hears ascent, descent, and summit under one handler id" do
    heard =
      KilimanjaroKiboCycle.with_handler(@handler_id, self(), fn ->
        assert {:ok, _} = KilimanjaroKiboCycle.fly(:ascent, 12_000)
        assert_receive {:kibo_heard, :ascent, 12_000}

        assert {:ok, _} = KilimanjaroKiboCycle.fly(:summit, 19_341)
        assert_receive {:kibo_heard, :summit, 19_341}

        assert {:ok, _} = KilimanjaroKiboCycle.fly(:descent, 8_000)
        assert_receive {:kibo_heard, :descent, 8_000}

        MapSet.new([:ascent, :summit, :descent])
      end)

    assert MapSet.size(heard) == 3
    assert {:error, :not_found} = :telemetry.detach(@handler_id)

    assert {:ok, _} = KilimanjaroKiboCycle.fly(:ascent, 10_000)
    refute_receive {:kibo_heard, _, _}, 50
  end

  test "a raising handler is detached and later Kibo events stay silent" do
    assert :ok =
             :telemetry.attach_many(
               @fragile_id,
               KilimanjaroKiboCycle.event_names(),
               fn _event, _measurements, _metadata, test_pid ->
                 send(test_pid, :fragile_fired)
                 raise "Kibo probe blew a fuse"
               end,
               self()
             )

    ExUnit.CaptureLog.capture_log(fn ->
      assert {:ok, _} = KilimanjaroKiboCycle.fly(:ascent, 9_000)
    end)

    assert_receive :fragile_fired

    assert {:error, :not_found} = :telemetry.detach(@fragile_id)

    assert {:ok, _} = KilimanjaroKiboCycle.fly(:descent, 7_000)
    refute_receive :fragile_fired, 50
  end

  test "the LiveView board lists legs after attach_many", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Kilimanjaro International"
    assert has_element?(view, "#listening-flag", "Listening on attach_many")
    assert has_element?(view, "#clerk-name", "Neema")
    assert has_element?(view, "#craft-name", "Cessna Caravan")

    view |> element("#fly-ascent") |> render_click()
    assert has_element?(view, "#leg-log", "ascent")
    assert has_element?(view, "#heard-phases", "ascent")

    view |> element("#fly-grounded") |> render_click()
    assert render(view) =~ "positive altitude"
  end
end
