defmodule PhoenixMultivitaminWeb.KrakowWawelNightStaffLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.{Presence, PresenceSync}

  @path "/features/16-presence/07-krakow-wawel-night-staff"
  @topic "presence:krakow-night-ramp"

  test "opening the page tracks nobody until the agent signs on", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Wojciech")
    PresenceSync.release_on_exit(view, Presence)

    assert has_element?(view, "#duty-state", "Off duty")
    assert Presence.list(@topic) == %{}

    view |> element("#sign-on-deice") |> render_click()
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#duty-state", "On duty since")
    assert has_element?(view, "#night-wojciech", "de-icing pad")
  end

  test "signing off untracks while the tab stays open", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Wojciech")
    PresenceSync.release_on_exit(view, Presence)

    view |> element("#sign-on-baggage") |> render_click()
    PresenceSync.settle(Presence, view)
    view |> element("#sign-off") |> render_click()
    PresenceSync.settle(Presence, view)

    assert has_element?(view, "#duty-state", "Off duty")
    assert has_element?(view, "#sign-on-deice")
    refute has_element?(view, "#night-wojciech")
    assert Presence.get_by_key(@topic, "Wojciech") == []
  end

  test "a repeated sign-on is refused as already tracked", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Agnieszka")
    PresenceSync.release_on_exit(view, Presence)

    view |> element("#sign-on-deice") |> render_click()
    PresenceSync.settle(Presence, view)
    render_click(view, "sign_on", %{"post" => "baggage hall"})

    assert has_element?(view, "#flash-error", "Agnieszka is already signed on for the night.")
    assert %{"Agnieszka" => %{metas: [%{post: "de-icing pad"}]}} = Presence.list(@topic)
  end

  test "signing off while off duty is refused", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path <> "?agent=Agnieszka")
    PresenceSync.release_on_exit(view, Presence)

    render_click(view, "sign_off", %{})

    assert has_element?(view, "#flash-error", "Nobody to sign off")
  end
end
