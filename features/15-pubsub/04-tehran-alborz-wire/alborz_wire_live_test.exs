defmodule PhoenixMultivitaminWeb.TehranAlborzWireLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/15-pubsub/04-tehran-alborz-wire"

  test "each station wire lands only in that station's column", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)

    desk |> form("#wire-form", station: "THR", notice: "Runway 29 closed for sweeping") |> render_submit()

    assert has_element?(desk, "#last-topic code", "alborz:THR")
    assert has_element?(desk, "#wire-THR li", "Runway 29 closed for sweeping")
    refute has_element?(desk, "#wire-IKA li")
  end

  test "a wire to an unwatched station goes out but never reaches this desk", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, "alborz:MHD")

    desk |> form("#wire-form", station: "MHD", notice: "Mashhad fog bank") |> render_submit()

    assert_receive {:alborz_wire, "alborz:MHD", "Mashhad fog bank"}
    refute has_element?(desk, "#wire-MHD")
    refute has_element?(desk, "li", "Mashhad fog bank")
  end

  test "outside broadcasts on a station topic land, and empty wires are rejected", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      "alborz:IKA",
      {:alborz_wire, "alborz:IKA", "De-icing at stand 12"}
    )

    assert has_element?(desk, "#wire-IKA li", "De-icing at stand 12")

    desk |> form("#wire-form", station: "IKA", notice: "") |> render_submit()
    assert has_element?(desk, "#flash-error", "known station")
  end
end
