defmodule PhoenixMultivitaminWeb.AbuDhabiYasStandCallLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/08-abu-dhabi-yas-stand-call"
  @topic "abu-dhabi:yas-stand-calls"

  test "a stand call reaches only that stand's marshal process", %{conn: conn} do
    {:ok, ramp, _html} = live(conn, @path)
    stand_31 = find_live_child(ramp, "marshal-31")
    stand_32 = find_live_child(ramp, "marshal-32")
    refute stand_31.pid == ramp.pid

    ramp |> form("#stand-call-form", stand: "31", flight: "ey17") |> render_submit()

    assert has_element?(stand_31, "#inbound-31", "EY17")
    assert has_element?(stand_32, "#inbound-32", "No aircraft called")
  end

  test "the marshal's reply comes back to the dispatcher on the same topic", %{conn: conn} do
    {:ok, ramp, _html} = live(conn, @path)
    stand_32 = find_live_child(ramp, "marshal-32")

    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {:stand_call, "32", "EY454"})
    stand_32 |> element("#ready-32-button") |> render_click()

    assert has_element?(ramp, "#ready-32", "Stand 32 ready · Joseph")
    refute has_element?(ramp, "#ready-31")
  end

  test "a marshal without an inbound aircraft cannot report ready", %{conn: conn} do
    {:ok, ramp, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
    stand_31 = find_live_child(ramp, "marshal-31")

    refute has_element?(stand_31, "#ready-31-button")
    render_click(stand_31, "marshal_ready", %{})
    refute_received {:marshal_ready, "31", _marshal}

    ramp |> form("#stand-call-form", stand: "31", flight: "") |> render_submit()
    assert has_element?(ramp, "#flash-error", "flight number")
    refute_received {:stand_call, "31", _flight}
  end
end
