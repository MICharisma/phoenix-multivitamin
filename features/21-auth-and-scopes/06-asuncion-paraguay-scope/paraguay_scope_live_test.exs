defmodule PhoenixMultivitaminWeb.AsuncionParaguayScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/21-auth-and-scopes/06-asuncion-paraguay-scope"

  test "without a paraguay_token the on_mount hook redirects to /", %{conn: conn} do
    assert {:error, {:redirect, %{to: "/"}}} = live(conn, @path)
  end

  test "with paraguay_token Thiago reaches the night ops board", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("paraguay_token", "thiago-asu")
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Thiago")
    assert has_element?(view, "#craft-name", "Airbus A320")
    assert has_element?(view, "#scope-controller", "Thiago")
    assert has_element?(view, "#scope-station", "ASU")
    assert has_element?(view, "#scope-watch", "night ops")
  end
end
