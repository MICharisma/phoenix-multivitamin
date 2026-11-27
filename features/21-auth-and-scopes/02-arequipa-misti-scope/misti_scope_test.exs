defmodule PhoenixMultivitaminWeb.ArequipaMistiScopeTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MistiAssignScope

  @path "/features/21-auth-and-scopes/02-arequipa-misti-scope"

  test "init/1 turns keyword opts into a map" do
    opts = MistiAssignScope.init(session_key: "misti_token", desk: "Misti ash desk")

    assert opts == %{session_key: "misti_token", desk: "Misti ash desk"}
  end

  test "plug assigns current_scope from misti_token", %{conn: conn} do
    opts = MistiAssignScope.init([])

    conn =
      conn
      |> init_test_session(%{})
      |> put_session("misti_token", "ines-aqp")
      |> MistiAssignScope.call(opts)

    assert %PhoenixMultivitaminWeb.MistiScope{
             dispatcher: "Inés",
             station: "AQP"
           } = conn.assigns.current_scope

    assert conn.assigns.desk == "Misti ash desk"
  end

  test "plug assigns nil scope when the token is missing", %{conn: conn} do
    opts = MistiAssignScope.init([])

    conn =
      conn
      |> init_test_session(%{})
      |> MistiAssignScope.call(opts)

    assert conn.assigns.current_scope == nil
  end

  test "LiveView without a token shows the locked ash desk", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Inés")
    assert has_element?(view, "#ash-locked")
    refute has_element?(view, "#misti-board")
  end

  test "LiveView with misti_token shows Inés at AQP", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("misti_token", "ines-aqp")
      |> live(@path)

    assert has_element?(view, "#scope-dispatcher", "Inés")
    assert has_element?(view, "#scope-station", "AQP")
    assert has_element?(view, "#desk-name", "Misti ash desk")
  end
end
