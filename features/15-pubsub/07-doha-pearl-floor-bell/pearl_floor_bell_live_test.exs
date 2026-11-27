defmodule PhoenixMultivitaminWeb.DohaPearlFloorBellLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Phoenix.Socket.Broadcast

  @path "/features/15-pubsub/07-doha-pearl-floor-bell"
  @topic "doha:pearl-transfer-floor"

  test "ringing a gate lights it on every supervisor screen", %{conn: conn} do
    {:ok, floor, _html} = live(conn, @path)
    {:ok, supervisor, _html} = live(build_conn(), @path)
    assert has_element?(floor, "#pubsub-server", "PhoenixMultivitamin.PubSub")

    floor |> element("#ring-D4") |> render_click()
    assert has_element?(supervisor, "#gate-D4.ringing")
    assert has_element?(supervisor, "#bell-log li", "Maryam rang D4")

    supervisor |> element("#silence-D4") |> render_click()
    refute has_element?(floor, "#gate-D4.ringing")
  end

  test "the endpoint wraps the payload in a Broadcast without encoding it", %{conn: conn} do
    {:ok, floor, _html} = live(conn, @path)
    @endpoint.subscribe(@topic)

    floor |> element("#ring-C12") |> render_click()

    assert_receive %Broadcast{
      topic: @topic,
      event: "ring",
      payload: %{gate: "C12", rung_by: "Maryam"}
    }
  end

  test "an atom event is refused before anything is broadcast" do
    @endpoint.subscribe(@topic)

    assert_raise FunctionClauseError, fn ->
      apply(@endpoint, :broadcast!, [@topic, :ring, %{gate: "E21"}])
    end

    refute_received %Broadcast{}
  end

  test "an unknown gate is never rung", %{conn: conn} do
    {:ok, floor, _html} = live(conn, @path)
    @endpoint.subscribe(@topic)

    render_click(floor, "ring_bell", %{"gate" => "Z9"})
    assert has_element?(floor, "#flash-error", "Pearl transfer floor")
    refute_received %Broadcast{event: "ring"}
  end
end
