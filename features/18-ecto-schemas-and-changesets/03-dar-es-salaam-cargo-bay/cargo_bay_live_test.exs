defmodule PhoenixMultivitaminWeb.DarCargoBayLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/03-dar-es-salaam-cargo-bay"

  test "embeds_one refuses an unbalanced bay and posts a balanced total", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Asha")

    view
    |> form("#cargo-card-form", %{
      cargo_card: %{bay: %{forward_kg: "1200", aft_kg: "100"}}
    })
    |> render_change()

    assert has_element?(view, "#cargo-card-form", "must stay within 400 kg of the forward bay")

    view
    |> form("#cargo-card-form", %{
      cargo_card: %{bay: %{forward_kg: "1200", aft_kg: "1100"}}
    })
    |> render_submit()

    assert has_element?(view, "#total-kg", "2300")
  end
end
