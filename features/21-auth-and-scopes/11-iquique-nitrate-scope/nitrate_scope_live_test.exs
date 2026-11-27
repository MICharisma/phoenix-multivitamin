defmodule PhoenixMultivitaminWeb.IquiqueNitrateScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.NitrateBoards
  alias PhoenixMultivitaminWeb.NitrateScope

  @path "/features/21-auth-and-scopes/11-iquique-nitrate-scope"

  test "topic names the Iquique station" do
    scope = NitrateScope.for_clerk("Valentina", "IQQ")
    assert NitrateBoards.topic(scope) == "iquique:IQQ:nitrate"
  end

  test "connected mount subscribes and posts broadcast a note", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("nitrate_clerk", "Valentina")
      |> put_session("nitrate_station", "IQQ")
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Valentina")
    assert has_element?(view, "#pubsub-topic", "iquique:IQQ:nitrate")
    assert has_element?(view, "#subscribed-state", "yes")

    view
    |> form("#nitrate-note-form", %{body: "Hangar door latched for BT-67"})
    |> render_submit()

    assert has_element?(view, "#nitrate-notes", "Hangar door latched for BT-67")
  end

  test "sign_out_station broadcast clears the scope via handle_info", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("nitrate_clerk", "Valentina")
      |> live(@path)

    assert has_element?(view, "#nitrate-board")

    view |> element("#sign-out-station") |> render_click()

    assert has_element?(view, "#nitrate-locked", "Signed out")
    refute has_element?(view, "#nitrate-board")
  end

  test "external logout broadcast reaches a subscribed LiveView", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> init_test_session(%{})
      |> put_session("nitrate_clerk", "Valentina")
      |> live(@path)

    scope = NitrateScope.for_clerk("Valentina", "IQQ")
    :ok = NitrateBoards.broadcast_logout(scope)

    assert render(view) =~ "Signed out"
    refute has_element?(view, "#nitrate-board")
  end
end
