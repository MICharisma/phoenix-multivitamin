defmodule PhoenixMultivitaminWeb.VigoRiasBaixasMigrationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.VigoBayCard
  alias PhoenixMultivitamin.VigoStand

  @path "/features/20-ecto-migrations-and-multis/03-vigo-rias-baixas-migration"

  test "mooring creates a stand, a bay card, and lists heavy cargo", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Carme")

    view
    |> form("#bay-form", bay: %{label: "Ría-9", cargo_kg: "1500"})
    |> render_submit()

    assert has_element?(view, "#stand-label", "Ría-9")
    assert has_element?(view, "#heavy-bays li")

    stand = Repo.get_by!(VigoStand, label: "Ría-9")
    assert Repo.get_by!(VigoBayCard, vigo_stand_id: stand.id).cargo_kg == 1500
  end

  test "a missing stand id raises because SQLite reports a nil constraint name", %{conn: _conn} do
    changeset =
      %VigoBayCard{}
      |> VigoBayCard.changeset(%{
        clerk: "Carme",
        craft: "Dash 8-400",
        cargo_kg: 900,
        vigo_stand_id: -1
      })

    # ecto_sqlite3 surfaces the FK failure with a nil constraint name, so
    # foreign_key_constraint/3 cannot convert it into a changeset error.
    assert_raise Ecto.ConstraintError, ~r/foreign_key_constraint/, fn ->
      Repo.insert(changeset)
    end
  end
end
