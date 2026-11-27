defmodule PhoenixMultivitaminWeb.CatalogLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Catalog

  test "the catalog lists every feature and the bottled count", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")

    bottled = Catalog.bottled_slots()

    assert html =~ "Phoenix Multivitamin"
    assert html =~ "325 of 325"
    assert html =~ "Routing and plugs"
    assert html =~ "LiveView lifecycle and events"
    assert html =~ "Function components and HEEx"
    assert html =~ "Testing"
    assert Enum.all?(bottled, &(html =~ &1.title))
  end

  test "every slot has a page", %{conn: conn} do
    for feature <- Catalog.features(), slot <- feature.slots do
      conn = get(conn, slot.path)

      case conn.status do
        200 ->
          assert html_response(conn, 200) =~ slot.title

        302 ->
          # Auth-gated LiveViews halt on_mount and redirect when the session is empty.
          assert redirected_to(conn)
      end
    end
  end

  test "a planned slot says it is planned, or the bottle is full", %{conn: conn} do
    slot =
      Catalog.features()
      |> Enum.find_value(fn feature ->
        Enum.find(feature.slots, &(not &1.bottled))
      end)

    if slot do
      {:ok, _view, html} = live(conn, slot.path)
      assert html =~ "planned"
      assert html =~ slot.title
    else
      assert Catalog.bottled_count() == Catalog.slot_count()
    end
  end
end
