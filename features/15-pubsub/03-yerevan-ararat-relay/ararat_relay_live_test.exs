defmodule PhoenixMultivitaminWeb.YerevanAraratRelayLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/03-yerevan-ararat-relay"
  @topic "yerevan:ararat-visibility"

  test "the relaying desk logs once and the other desk hears it", %{conn: conn} do
    {:ok, zvartnots, _html} = live(conn, @path)
    {:ok, gyumri, _html} = live(build_conn(), @path <> "?desk=gyumri")
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    zvartnots |> form("#visibility-form", metres: "1800") |> render_submit()

    assert_receive {:ararat_visibility, %{desk: "Zvartnots tower", visibility_m: 1800}}
    assert has_element?(zvartnots, "#report-count", "1 reports logged")
    assert has_element?(zvartnots, "#visibility-log li", "You relayed 1800 m")
    assert has_element?(gyumri, "#desk-name", "Gyumri Shirak tower")
    assert has_element?(gyumri, "#visibility-log li", "Zvartnots tower: 1800 m")
  end

  test "an unknown desk falls back to Zvartnots and bad visibility is not relayed", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path <> "?desk=sevan")
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
    assert has_element?(desk, "#desk-name", "Zvartnots tower")

    desk |> form("#visibility-form", metres: "12000") |> render_submit()
    desk |> form("#visibility-form", metres: "fog") |> render_submit()

    assert has_element?(desk, "#flash-error", "50 to 10,000 metres")
    assert has_element?(desk, "#report-count", "0 reports logged")
    refute_received {:ararat_visibility, _report}
  end

  test "a report from outside the desks still lands through handle_info", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:ararat_visibility, %{desk: "Kapan approach", visibility_m: 600}}
    )

    assert has_element?(desk, "#visibility-log li", "Kapan approach: 600 m")
  end
end
