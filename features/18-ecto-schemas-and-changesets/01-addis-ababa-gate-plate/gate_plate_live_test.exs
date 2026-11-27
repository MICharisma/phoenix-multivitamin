defmodule PhoenixMultivitaminWeb.AddisGatePlateLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/01-addis-ababa-gate-plate"

  test "embedded gate plate validates souls and posts the gate", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)
    assert html =~ "Addis Ababa gate plate"
    assert has_element?(view, "#clerk-name", "Tigist")
    assert has_element?(view, "#craft-name", "Boeing 787-8")

    view
    |> form("#gate-plate-form", gate_plate: %{souls: "0"})
    |> render_change()

    assert has_element?(view, "#gate-plate-form", "must be greater than 0")

    view
    |> form("#gate-plate-form", gate_plate: %{gate: "B9", souls: "214"})
    |> render_submit()

    assert has_element?(view, "#posted-gate", "B9")
  end
end
