defmodule PhoenixMultivitaminWeb.ConcepcionBiobioScopeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.BiobioScope
  alias PhoenixMultivitaminWeb.BiobioSudo

  @path "/features/21-auth-and-scopes/10-concepcion-biobio-scope"

  test "sudo_valid? accepts a fresh authenticated_at and rejects a stale one" do
    fresh = BiobioScope.for_clerk("Ignacio", DateTime.utc_now())
    stale_at = DateTime.add(DateTime.utc_now(), -BiobioSudo.sudo_window_seconds() - 30, :second)
    stale = BiobioScope.for_clerk("Ignacio", stale_at)

    assert BiobioSudo.sudo_valid?(fresh)
    refute BiobioSudo.sudo_valid?(stale)
    refute BiobioSudo.sudo_valid?(nil)
  end

  test "fresh session unlocks the master plate drawer", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> signed_in_conn(DateTime.utc_now())
      |> live(@path)

    assert has_element?(view, "#clerk-name", "Ignacio")
    assert has_element?(view, "#sudo-state", "valid")
    assert has_element?(view, "#drawer-state", "locked")

    view |> element("#unlock-master-plates") |> render_click()

    assert has_element?(view, "#drawer-state", "open")
    assert has_element?(view, "#drawer-message", "Master plates unlocked for Ignacio")
  end

  test "stale authenticated_at fails unlock until renew_session", %{conn: conn} do
    stale_at = DateTime.add(DateTime.utc_now(), -BiobioSudo.sudo_window_seconds() - 60, :second)

    {:ok, view, _html} =
      conn
      |> signed_in_conn(stale_at)
      |> live(@path)

    assert has_element?(view, "#sudo-state", "stale")

    view |> element("#unlock-master-plates") |> render_click()

    assert has_element?(view, "#drawer-state", "locked")
    assert has_element?(view, "#drawer-message", "Sudo window expired")
    assert render(view) =~ "Sudo required"

    view |> element("#renew-session") |> render_click()

    assert has_element?(view, "#sudo-state", "valid")
    assert has_element?(view, "#drawer-message", "Session renewed")

    view |> element("#unlock-master-plates") |> render_click()

    assert has_element?(view, "#drawer-state", "open")
  end

  defp signed_in_conn(conn, %DateTime{} = at) do
    conn
    |> init_test_session(%{})
    |> put_session("biobio_clerk", "Ignacio")
    |> put_session("biobio_authenticated_at", DateTime.to_iso8601(at))
  end
end
