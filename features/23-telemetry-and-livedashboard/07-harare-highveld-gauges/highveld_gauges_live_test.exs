defmodule PhoenixMultivitaminWeb.HarareHighveldGaugesLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.HarareHighveldGauges

  @path "/features/23-telemetry-and-livedashboard/07-harare-highveld-gauges"
  @handler_id {__MODULE__, :highveld}

  setup do
    on_exit(fn -> :telemetry.detach(@handler_id) end)
    :ok
  end

  test "summary and distribution share the departure event and tag runway via capture" do
    [summary, distribution] = HarareHighveldGauges.metrics()

    assert %Telemetry.Metrics.Summary{} = summary
    assert %Telemetry.Metrics.Distribution{} = distribution
    assert summary.event_name == [:harare, :highveld, :departure]
    assert distribution.event_name == summary.event_name
    assert summary.tags == [:runway]
    assert distribution.tags == [:runway]
    assert summary.measurement == :roll_ms
    assert is_function(summary.tag_values, 1)
    assert summary.tag_values.(%{runway: "05", flight: "FN 814"}) == %{runway: "05"}
  end

  test "depart emits roll_ms and group_by clusters flights by runway" do
    :ok =
      :telemetry.attach(
        @handler_id,
        HarareHighveldGauges.event_name(),
        fn _, measurements, metadata, pid -> send(pid, {:roll, measurements, metadata}) end,
        self()
      )

    assert {:ok, first} =
             HarareHighveldGauges.depart(%{flight: "FN 814", runway: "05", roll_ms: 28_500})

    assert {:ok, second} =
             HarareHighveldGauges.depart(%{flight: "FN 902", runway: "17", roll_ms: 31_200})

    assert_receive {:roll, %{roll_ms: 28_500},
                    %{flight: "FN 814", runway: "05", station: "Harare International"}}

    assert_receive {:roll, %{roll_ms: 31_200}, %{runway: "17", plateau: "Highveld"}}

    grouped = HarareHighveldGauges.group_by_runway([first, second])
    assert Map.keys(grouped) |> Enum.sort() == ["05", "17"]
    assert length(grouped["05"]) == 1
  end

  test "the LiveView board groups departures by runway", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#metric-summary", "harare.highveld.departure.roll_ms")
    assert has_element?(view, "#metric-distribution", "harare.highveld.departure.roll_ms")
    assert has_element?(view, "#clerk-name", "Rudo")
    assert has_element?(view, "#craft-name", "Embraer 145")

    view |> element("#depart-05") |> render_click()
    assert has_element?(view, "#runway-05", "FN 814")

    view |> element("#depart-17") |> render_click()
    assert has_element?(view, "#runway-17", "FN 902")

    view |> element("#depart-bad") |> render_click()
    assert render(view) =~ "positive millisecond"
  end
end
