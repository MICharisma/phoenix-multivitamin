defmodule PhoenixMultivitaminWeb.AmmanNabateanHailLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.NabateanWatchSender

  @path "/features/15-pubsub/12-amman-nabatean-hail"
  @topic "amman:nabatean-station"

  defp hail(view, target, text) do
    view |> form("#hail-form", target: target, text: text) |> render_submit()
  end

  test "station hails reach every watch, watch hails only their watch", %{conn: conn} do
    {:ok, petra, _html} = live(conn, @path)
    {:ok, wadi_rum, _html} = live(build_conn(), @path <> "?watch=wadi-rum")

    hail(petra, "station", "Marka closes at 2300")
    hail(petra, "wadi-rum", "Balloon launch at dawn")

    assert has_element?(petra, ".hail-station", "Marka closes at 2300")
    refute has_element?(petra, "#hail-log li", "Balloon launch")
    assert has_element?(wadi_rum, ".hail-station", "Marka closes at 2300")
    assert has_element?(wadi_rum, ".hail-watch", "Balloon launch at dawn")
  end

  test "patching to another watch swaps the sender subscription", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)
    assert [{_pid, [NabateanWatchSender | "petra"]}] = Registry.lookup(PhoenixMultivitamin.PubSub, @topic)

    desk |> element("#switch-dead-sea") |> render_click()
    assert has_element?(desk, "#current-watch", "Dead Sea watch")
    assert [{_pid, [NabateanWatchSender | "dead-sea"]}] = Registry.lookup(PhoenixMultivitamin.PubSub, @topic)

    hail(desk, "petra", "Siq closed to vehicles")
    hail(desk, "dead-sea", "Low-level haze below sea level")
    refute has_element?(desk, "#hail-log li", "Siq")
    assert has_element?(desk, ".hail-watch", "Low-level haze")
  end

  test "a plain subscriber on the same topic sees every hail untouched", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    hail(desk, "dead-sea", "Potash plant stack lit")

    assert_receive {:nabatean_hail, "dead-sea", "Potash plant stack lit"}
    refute has_element?(desk, "#hail-log li")
  end

  test "an unknown watch falls back to Petra and cannot be hailed", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path <> "?watch=aqaba")
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
    assert has_element?(desk, "#current-watch", "Petra watch")

    render_submit(desk, "hail", %{"target" => "aqaba", "text" => "Gulf winds"})
    assert has_element?(desk, "#flash-error", "Hail the station")
    refute_received {:nabatean_hail, _target, _text}
  end
end
