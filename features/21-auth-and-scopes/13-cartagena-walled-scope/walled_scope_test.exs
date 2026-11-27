defmodule PhoenixMultivitaminWeb.CartagenaWalledScopeTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.WalledAuth
  alias PhoenixMultivitaminWeb.WalledHarbour
  alias PhoenixMultivitaminWeb.WalledScope

  @path "/features/21-auth-and-scopes/13-cartagena-walled-scope"

  test "fetch_current_scope plug assigns a CTG scope via Plug.call", %{conn: conn} do
    opts = WalledAuth.init([])

    conn =
      conn
      |> ctg_session()
      |> WalledAuth.call(opts)

    assert %WalledScope{clerk: "Catalina", station: "CTG"} = conn.assigns.current_scope
  end

  test "list_harbour_slips returns CTG slips and refuses Barranquilla", %{conn: _conn} do
    ctg = WalledScope.for_clerk("Catalina", "CTG")
    baq = WalledScope.for_clerk("Catalina", "BAQ")

    assert {:ok, slips} = WalledHarbour.list_harbour_slips(ctg)
    assert Enum.all?(slips, &(&1.station == "CTG"))
    assert Enum.any?(slips, &(&1.id == "slip-bocagrande"))

    assert {:error, :forbidden} = WalledHarbour.list_harbour_slips(baq)
    assert {:error, :forbidden} = WalledHarbour.list_harbour_slips(nil)
  end

  test "CTG session opens harbour slips and renews", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> ctg_session()
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Catalina")
    assert has_element?(view, "#scope-station", "CTG")
    assert has_element?(view, "#harbour-slips", "Bocagrande seaplane slip")
    assert has_element?(view, "#harbour-topic", "cartagena:CTG:harbour")

    view |> element("#renew-session") |> render_click()

    assert has_element?(view, "#renew-message", "Harbour session renewed")
    assert has_element?(view, "#authenticated-at")
  end

  test "Barranquilla session is refused for the CTG board", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("walled_clerk", "Catalina")
      |> put_session("walled_station", "BAQ")
      |> put_session("walled_authenticated_at", DateTime.to_iso8601(DateTime.utc_now()))
      |> live(@path)

    assert has_element?(view, "#wrong-station", "BAQ")
    refute has_element?(view, "#harbour-slips")
    assert render(view) =~ "Barranquilla scope cannot open the CTG harbour"
  end

  test "sign_out_harbour broadcast clears the CTG desk", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> ctg_session()
      |> live(@path)

    view |> element("#sign-out-harbour") |> render_click()

    assert has_element?(view, "#harbour-locked", "Signed out")
    refute has_element?(view, "#walled-board")
  end

  defp ctg_session(conn) do
    conn
    |> init_test_session(%{})
    |> put_session("walled_clerk", "Catalina")
    |> put_session("walled_station", "CTG")
    |> put_session("walled_authenticated_at", DateTime.to_iso8601(DateTime.utc_now()))
  end
end
