defmodule PhoenixMultivitaminWeb.PamplonaSanFerminMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.PamplonaPlate
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/08-pamplona-san-fermin-multi"

  test "Multi.run prices the mid-band gate fee and updates the plate", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#plate-form", plate: %{stand: "SF-7", litres: "4500"})
    |> render_submit()

    assert has_element?(view, "#stamped-stand", "SF-7")
    assert has_element?(view, "#gate-fee", "240")
    assert Repo.get_by!(PamplonaPlate, stand: "SF-7").gate_fee_eur == 240
  end

  test "non-positive litres never starts the multi", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#plate-form", plate: %{stand: "SF-1", litres: "0"})
    |> render_submit()

    assert render(view) =~ "Litres must be positive"
    assert Repo.aggregate(PamplonaPlate, :count) == 0
  end
end
