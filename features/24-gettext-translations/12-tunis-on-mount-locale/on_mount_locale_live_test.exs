defmodule PhoenixMultivitaminWeb.TunisOnMountLocaleLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/24-gettext-translations/12-tunis-on-mount-locale"

  test "on_mount defaults to French without a session locale", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Amira"
    assert has_element?(view, "#locale", "fr")
    assert html =~ "Repoussage approuvé depuis le stand 14"
    assert has_element?(view, "#mount-saw-locale", "true")
  end

  test "on_mount puts Arabic when the session carries locale=ar", %{conn: conn} do
    {:ok, view, html} =
      conn
      |> init_test_session(%{"locale" => "ar"})
      |> live(@path)

    assert has_element?(view, "#locale", "ar")
    assert html =~ "تمت الموافقة على الدفع من الموقف 14"
  end
end
