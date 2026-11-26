defmodule PhoenixMultivitaminWeb.MontevideoRamblaScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.RamblaAuth
  alias PhoenixMultivitaminWeb.RamblaScope

  @path "/features/21-auth-and-scopes/07-montevideo-rambla-scope"

  test "without a rambla_token require_authenticated redirects to /", %{conn: conn} do
    assert {:error, {:redirect, %{to: "/"}}} = live(conn, @path)
  end

  test "with rambla_token Sofía reaches the METAR desk", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("rambla_token", "sofia-mvd")
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Sofía")
    assert has_element?(view, "#craft-name", "Embraer E190")
    assert has_element?(view, "#scope-clerk", "Sofía")
    assert has_element?(view, "#scope-station", "MVD")
    assert has_element?(view, "#scope-desk", "Rambla METAR")
    assert has_element?(view, "#metar-line", "MVD 261800Z")
  end

  test "mount_current_scope always assigns current_scope" do
    socket = %Phoenix.LiveView.Socket{}

    assert {:cont, mounted} =
             RamblaAuth.on_mount(:mount_current_scope, %{}, %{"rambla_token" => "sofia-mvd"}, socket)

    assert %RamblaScope{clerk: "Sofía", station: "MVD"} = mounted.assigns.current_scope

    assert {:cont, guest} = RamblaAuth.on_mount(:mount_current_scope, %{}, %{}, socket)
    assert guest.assigns.current_scope == nil
  end
end
