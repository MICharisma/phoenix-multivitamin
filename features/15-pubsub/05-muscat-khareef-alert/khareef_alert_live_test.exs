defmodule PhoenixMultivitaminWeb.MuscatKhareefAlertLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/05-muscat-khareef-alert"
  @topic "muscat:khareef-alerts"

  test "a reported gust is classified, broadcast, and received", %{conn: conn} do
    {:ok, ops, _html} = live(conn, @path)

    ops |> form("#gust-form", gust_kt: "48") |> render_submit()
    assert has_element?(ops, "#khareef-alert", "Alert 1: RED · gusting 48 kt")

    ops |> form("#gust-form", gust_kt: "18") |> render_submit()
    assert has_element?(ops, "#advisories li", "Gusting 18 kt")
    assert has_element?(ops, "#khareef-alert", "RED")
  end

  test "only the clear timer for the current serial lifts the alert", %{conn: conn} do
    {:ok, ops, _html} = live(conn, @path)

    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {:khareef, :amber, %{gust_kt: 34}})
    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {:khareef, :red, %{gust_kt: 46}})
    assert has_element?(ops, "#khareef-alert", "Alert 2: RED")

    send(ops.pid, {:clear_alert, 1})
    assert has_element?(ops, "#khareef-alert", "Alert 2")
    assert has_element?(ops, "#ignored-count", "1 stale")

    send(ops.pid, {:clear_alert, 2})
    assert has_element?(ops, "#khareef-clear")
  end

  test "malformed broadcasts fall to the catch-all instead of crashing", %{conn: conn} do
    {:ok, ops, _html} = live(conn, @path)

    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {:khareef, :red, %{gust_kt: "strong"}})
    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {:sandstorm, :amber})

    assert has_element?(ops, "#ignored-count", "2 stale or unknown")
    assert has_element?(ops, "#khareef-clear")
  end
end
