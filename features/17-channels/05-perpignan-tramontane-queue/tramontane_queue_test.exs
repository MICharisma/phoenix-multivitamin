defmodule PhoenixMultivitaminWeb.PerpignanTramontaneQueueTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.{PerpignanTramontaneChannel, PerpignanTramontaneSocket}

  @path "/features/17-channels/05-perpignan-tramontane-queue"

  setup do
    {:ok, socket} = connect(PerpignanTramontaneSocket, %{})

    queue =
      for {flight, type} <- [{"VY1471", "A320"}, {"T7 225", "Q400"}, {"F-GTPC", "C172"}],
          into: %{} do
        {:ok, %{flight: ^flight}, departure} =
          subscribe_and_join(socket, "tramontane:queue", %{flight: flight, type: type})

        {type, departure}
      end

    %{queue: queue}
  end

  test "runway_wind computes the crosswind for the runway in use" do
    assert PerpignanTramontaneChannel.runway_wind(290, 44) ==
             %{runway: "33", wind: "290/44KT", crosswind_kt: 28}

    assert %{runway: "15", crosswind_kt: 0} = PerpignanTramontaneChannel.runway_wind(150, 20)
  end

  test "one broadcast is rewritten per departure by handle_out", %{queue: %{"A320" => vueling}} do
    broadcast_from!(vueling, "runway_wind", PerpignanTramontaneChannel.runway_wind(290, 44))

    assert_push "runway_wind", %{runway: "33", crosswind_kt: 28, margin_kt: 10}
    assert_push "runway_wind", %{margin_kt: 4}
    assert_push "hold_for_tramontane", %{flight: "F-GTPC", exceeds_by_kt: 13}
    refute_push "runway_wind", %{margin_kt: _negative}
  end

  test "the tower form broadcasts through the endpoint and holds every departure" do
    {:ok, view, _html} = live(build_conn(), @path)

    view
    |> form("#tower-wind-form", wind: %{direction: "270", speed_kt: "48"})
    |> render_submit()

    assert has_element?(view, "#posted-wind", "crosswind 42 kt")
    assert_broadcast "runway_wind", %{crosswind_kt: 42}

    for flight <- ["VY1471", "T7 225", "F-GTPC"] do
      assert_push "hold_for_tramontane", %{flight: ^flight}
    end

    refute_push "runway_wind", _released
  end

  test "an unreadable wind is not broadcast" do
    {:ok, view, _html} = live(build_conn(), @path)

    html =
      view
      |> form("#tower-wind-form", wind: %{direction: "NW", speed_kt: "48"})
      |> render_submit()

    assert html =~ "Wind must be ddd/ss"
    refute_broadcast "runway_wind", _wind
  end

  test "a type without a demonstrated crosswind cannot join the queue" do
    {:ok, socket} = connect(PerpignanTramontaneSocket, %{})

    assert {:error, %{reason: "no demonstrated crosswind on file for that type"}} =
             join(socket, "tramontane:queue", %{flight: "F-PZAP", type: "Pou-du-Ciel"})
  end
end
