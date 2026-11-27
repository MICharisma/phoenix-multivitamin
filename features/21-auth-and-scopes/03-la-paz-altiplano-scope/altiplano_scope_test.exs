defmodule PhoenixMultivitaminWeb.LaPazAltiplanoScopeTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.AltiplanoRequireAuth
  alias PhoenixMultivitaminWeb.AltiplanoScope

  @path "/features/21-auth-and-scopes/03-la-paz-altiplano-scope"

  test "missing token redirects to the roster path and halts", %{conn: conn} do
    opts = AltiplanoRequireAuth.init([])

    conn =
      conn
      |> init_test_session(%{})
      |> AltiplanoRequireAuth.call(opts)

    assert redirected_to(conn) == @path
    assert conn.halted
    refute Map.has_key?(conn.assigns, :current_scope)
  end

  test "valid altiplano_token assigns Camila's scope", %{conn: conn} do
    opts = AltiplanoRequireAuth.init([])

    conn =
      conn
      |> init_test_session(%{})
      |> put_session("altiplano_token", "camila-lpb")
      |> AltiplanoRequireAuth.call(opts)

    refute conn.halted

    assert %AltiplanoScope{clerk: "Camila", station: "LPB"} = conn.assigns.current_scope
  end

  test "call_without_halt redirects but leaves the conn unhalted", %{conn: conn} do
    opts = AltiplanoRequireAuth.init([])

    conn =
      conn
      |> init_test_session(%{})
      |> AltiplanoRequireAuth.call_without_halt(opts)

    assert redirected_to(conn) == @path
    refute conn.halted

    assert_raise Plug.Conn.AlreadySentError, fn ->
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "oxygen crib still open")
    end
  end

  test "LiveView without a token shows the oxygen roster", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Camila")
    assert has_element?(view, "#oxygen-roster")
    refute has_element?(view, "#oxygen-board")
  end

  test "LiveView with altiplano_token shows Camila at LPB", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("altiplano_token", "camila-lpb")
      |> live(@path)

    assert has_element?(view, "#scope-clerk", "Camila")
    assert has_element?(view, "#scope-station", "LPB")
    assert has_element?(view, "#scope-desk", "El Alto oxygen")
  end
end
