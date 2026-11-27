defmodule PhoenixMultivitaminWeb.VisbyGotlandRadioLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.PresenceSync
  alias PhoenixMultivitaminWeb.VisbyGotlandPresence, as: NetPresence

  @path "/features/16-presence/13-visby-gotland-radio"
  @topic "presence:gotland-radio-net"

  setup %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?station=Visby+Radio")
    PresenceSync.release_on_exit(view, NetPresence)
    PresenceSync.settle(NetPresence, view)
    %{view: view}
  end

  test "stations are overlaid with their site and operator", %{view: view} do
    assert has_element?(view, "#station-visby-radio", "Ebba at Visby airport tower")

    PresenceSync.track_peer(NetPresence, @topic, "Fårö Relay", %{frequency: "123.450"}, view)
    assert has_element?(view, "#station-faro-relay", "Linnea at Fårö lighthouse mast")

    assert has_element?(
             view,
             "#radio-log li",
             "Fårö Relay joined the net from Fårö lighthouse mast"
           )

    assert %{"Fårö Relay" => %{operator: "Linnea", metas: [%{frequency: "123.450"}]}} =
             NetPresence.list(@topic)
  end

  test "an unlisted station still joins the net", %{view: view} do
    PresenceSync.track_peer(NetPresence, @topic, "Ljugarn Mobile", %{frequency: "122.800"}, view)
    assert has_element?(view, "#station-ljugarn-mobile", "unlisted operator at unlisted site")
  end

  test "retuning updates this console's meta and logs the new frequency", %{view: view} do
    view |> form("#retune-form", retune: %{frequency: "122.15"}) |> render_submit()
    PresenceSync.settle(NetPresence, view)

    assert has_element?(view, "#station-visby-radio .frequencies", "122.150")
    assert has_element?(view, "#radio-log li", "Visby Radio now on 122.150")
    assert %{metas: [%{frequency: "122.150"}]} = NetPresence.get_by_key(@topic, "Visby Radio")
  end

  test "a frequency outside the airband is refused", %{view: view} do
    view |> form("#retune-form", retune: %{frequency: "88.700"}) |> render_submit()

    assert has_element?(view, "#retune-form", "must be an airband frequency")
    assert has_element?(view, "#station-visby-radio .frequencies", "118.300")
  end

  test "a second console for one call sign is counted, then closed", %{view: view} do
    second =
      PresenceSync.track_peer(NetPresence, @topic, "Visby Radio", %{frequency: "121.500"}, view)

    assert has_element?(view, "#station-visby-radio .consoles", "2")
    assert has_element?(view, "#station-visby-radio .frequencies", "118.300 / 121.500")
    assert has_element?(view, "#radio-log li", "Visby Radio opened console 2")

    PresenceSync.drop(NetPresence, second, view)
    assert has_element?(view, "#station-visby-radio .consoles", "1")
    assert has_element?(view, "#radio-log li", "Visby Radio is down to 1 console(s)")
  end

  test "signing off untracks and signing on tracks again", %{view: view} do
    view |> element("#sign-off") |> render_click()
    PresenceSync.settle(NetPresence, view)

    refute has_element?(view, "#station-visby-radio")
    assert has_element?(view, "#radio-log li", "Visby Radio left the net")

    render_click(view, "retune", %{"retune" => %{"frequency" => "119.000"}})
    assert has_element?(view, "#flash-error", "Sign on to the net before retuning.")

    view |> element("#sign-on") |> render_click()
    PresenceSync.settle(NetPresence, view)

    assert has_element?(view, "#station-visby-radio")

    assert has_element?(
             view,
             "#radio-log li",
             "Visby Radio joined the net from Visby airport tower"
           )
  end
end
