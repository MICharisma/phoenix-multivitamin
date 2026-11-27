defmodule PhoenixMultivitaminWeb.VarnaGoldenSandsTalkTest do
  use PhoenixMultivitaminWeb.ChannelCase
  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.VarnaGoldenSandsSocket

  @path "/features/17-channels/12-varna-golden-sands-talk"

  defp open_desk(latency_ms) do
    {:ok, socket} = connect(VarnaGoldenSandsSocket, %{handler: "Desislava Petrova"})

    {:ok, %{handler: "Desislava Petrova", network_latency_ms: ^latency_ms}, slots} =
      subscribe_and_join(socket, "golden_sands:slots", %{network_latency_ms: latency_ms})

    slots
  end

  test "socket_ref/1 lets a Task reply after handle_in returns :noreply" do
    slots = open_desk(20)

    ref =
      push(slots, "request_ctot", %{
        flight: "W6 2471",
        eobt: "09:40",
        destination: "EGKK"
      })

    refute_reply ref, :ok, _ctot, 5

    assert_reply ref,
                 :ok,
                 %{flight: "W6 2471", ctot: "10:27", regulation: "EGKKA26", delay_min: 35},
                 200
  end

  test "an unknown destination and a bad EOBT reply through the same async path" do
    slots = open_desk(5)

    ref =
      push(slots, "request_ctot", %{
        flight: "QS 1482",
        eobt: "14:05",
        destination: "LKPR"
      })

    assert_reply ref, :error, %{flight: "QS 1482", reason: "no flight plan filed to LKPR"}

    ref =
      push(slots, "request_ctot", %{
        flight: "FB 981",
        eobt: "eleven",
        destination: "ESSA"
      })

    assert_reply ref, :error, %{reason: "EOBT must be HH:MM"}
  end

  test "a second request for the same flight while one is pending is refused" do
    slots = open_desk(80)

    first =
      push(slots, "request_ctot", %{
        flight: "FB 981",
        eobt: "11:15",
        destination: "ESSA"
      })

    second =
      push(slots, "request_ctot", %{
        flight: "FB 981",
        eobt: "11:15",
        destination: "ESSA"
      })

    assert_reply second, :error, %{reason: "CTOT already requested"}
    assert_reply first, :ok, %{ctot: "11:42", regulation: "ESSAW26"}, 300
  end

  test "the slot board hands latency and push timeout to the JS client" do
    {:ok, view, _html} = live(build_conn(), @path)

    assert has_element?(
             view,
             "#golden-sands-talk[data-network-latency-ms='1200'][data-push-timeout-ms='500']"
           )

    assert has_element?(
             view,
             "#golden-sands-talk button[data-flight='W6 2471'][data-destination='EGKK']"
           )
  end
end
