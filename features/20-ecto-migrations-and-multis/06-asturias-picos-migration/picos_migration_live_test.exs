defmodule PhoenixMultivitaminWeb.AsturiasPicosMigrationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.AsturiasPicosCard
  alias PhoenixMultivitamin.AsturiasPicosDesk
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/06-asturias-picos-migration"

  test "seeded legacy phases stay unknown until the backfill runs", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#execute-documented", "true")

    render_click(view, "seed_legacy")
    assert has_element?(view, "#seeded", "true")
    assert has_element?(view, "#tally-unknown", "unknown: 3")

    render_click(view, "replay_backfill")
    assert has_element?(view, "#tally-climb", "climb: 2")
    assert has_element?(view, "#tally-cruise", "cruise: 1")
    refute has_element?(view, "#tally-unknown")

    assert AsturiasPicosDesk.phase_tallies() == %{"climb" => 2, "cruise" => 1}
    assert Repo.aggregate(AsturiasPicosCard, :count) == 3
  end
end
