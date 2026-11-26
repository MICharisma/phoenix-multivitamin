defmodule PhoenixMultivitaminWeb.BakuCaspianHandoverLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/01-baku-caspian-handover"
  @topic "baku:caspian-handovers"

  test "the static render does not subscribe the request process", %{conn: conn} do
    html = conn |> get(@path) |> html_response(200)
    assert html =~ "Static render: not subscribed yet"

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:handover_posted, "Absheron", "Rauf"}
    )

    refute_received {:handover_posted, _sector, _controller}
  end

  test "a posted handover reaches the posting desk and a second desk", %{conn: conn} do
    {:ok, posting_desk, _html} = live(conn, @path)
    {:ok, second_desk, _html} = live(build_conn(), @path)
    assert has_element?(posting_desk, "#listening-state", "Subscribed")

    posting_desk
    |> form("#handover-form", handover: %{sector: "Caspian-South", controller: " Elnur "})
    |> render_submit()

    assert has_element?(posting_desk, "#handover-0", "Caspian-South handed to Elnur")
    assert has_element?(second_desk, "#handover-0", "Caspian-South handed to Elnur")
  end

  test "an outside broadcast lands, and an unknown sector is never broadcast", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:handover_posted, "Absheron", "Rauf"}
    )

    assert has_element?(desk, "#handover-0", "Absheron handed to Rauf")

    render_submit(desk, "post_handover", %{
      "handover" => %{"sector" => "Tbilisi-East", "controller" => "Nino"}
    })

    assert has_element?(desk, "#flash-error", "Caspian sectors")
    assert_received {:handover_posted, "Absheron", "Rauf"}
    refute_received {:handover_posted, "Tbilisi-East", _controller}
  end
end
