defmodule PhoenixMultivitaminWeb.TbilisiMtatsmindaReliefLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MtatsmindaRelief

  @path "/features/15-pubsub/02-tbilisi-mtatsminda-relief"
  @tower_topic "tbilisi:mtatsminda-reliefs"

  setup do
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @tower_topic)
  end

  test "a valid relief is broadcast as a struct the tower can match", %{conn: conn} do
    {:ok, rota_desk, _html} = live(conn, @path)

    rota_desk
    |> form("#relief-form", relief: %{position: "Approach", incoming: "Giorgi", minutes: "45"})
    |> render_submit()

    assert_receive %MtatsmindaRelief{position: "Approach", incoming: "Giorgi", minutes: 45}
    assert has_element?(rota_desk, "#relief-Approach-Giorgi", "Giorgi in 45 min")
  end

  test "rejected reliefs never leave the desk", %{conn: conn} do
    {:ok, rota_desk, _html} = live(conn, @path)

    rota_desk
    |> form("#relief-form", relief: %{position: "Tower", incoming: "Tamar", minutes: "120"})
    |> render_submit()

    assert has_element?(rota_desk, "#flash-error", "relief window")

    rota_desk
    |> form("#relief-form", relief: %{position: "Tower", incoming: "  ", minutes: "20"})
    |> render_submit()

    assert has_element?(rota_desk, "#flash-error", "no incoming controller")

    render_submit(rota_desk, "send_relief", %{
      "relief" => %{"position" => "Radar", "incoming" => "Tamar", "minutes" => "20"}
    })

    assert has_element?(rota_desk, "#flash-error", "unknown position")
    refute_received %MtatsmindaRelief{}
    refute has_element?(rota_desk, "#sent-reliefs li")
  end

  test "the publishing desk is not subscribed to its own topic", %{conn: conn} do
    {:ok, rota_desk, _html} = live(conn, @path)

    subscribers = Registry.lookup(PhoenixMultivitamin.PubSub, @tower_topic)
    assert Enum.map(subscribers, &elem(&1, 0)) == [self()]
    refute rota_desk.pid in Enum.map(subscribers, &elem(&1, 0))
  end
end
