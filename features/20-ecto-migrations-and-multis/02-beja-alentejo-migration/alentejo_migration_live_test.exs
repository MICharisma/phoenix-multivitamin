defmodule PhoenixMultivitaminWeb.BejaAlentejoMigrationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.BejaApronSlip
  alias PhoenixMultivitamin.BejaApronSlipsMigration
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/02-beja-alentejo-migration"

  test "up and down are exported; change/0 is not", %{conn: conn} do
    {:module, _} = Code.ensure_loaded(BejaApronSlipsMigration)
    assert function_exported?(BejaApronSlipsMigration, :up, 0)
    assert function_exported?(BejaApronSlipsMigration, :down, 0)
    refute function_exported?(BejaApronSlipsMigration, :change, 0)

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#migration-direction", "up_and_down")

    view
    |> form("#apron-slip-form", apron_slip: %{stand: "B7", chocks_on: "true"})
    |> render_submit()

    assert has_element?(view, "#written-stand", "B7")
    assert Repo.get_by!(BejaApronSlip, stand: "B7").chocks_on
  end
end
