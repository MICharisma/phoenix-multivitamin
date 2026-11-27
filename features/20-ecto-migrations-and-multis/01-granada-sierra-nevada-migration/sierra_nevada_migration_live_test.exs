defmodule PhoenixMultivitaminWeb.GranadaSierraNevadaMigrationLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.GranadaMetarCard
  alias PhoenixMultivitamin.GranadaMetarCardsMigration
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/01-granada-sierra-nevada-migration"

  test "change/0 is exported and a METAR row lands after submit", %{conn: conn} do
    {:module, _} = Code.ensure_loaded(GranadaMetarCardsMigration)
    assert function_exported?(GranadaMetarCardsMigration, :change, 0)
    refute function_exported?(GranadaMetarCardsMigration, :up, 0)

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Inés")
    assert has_element?(view, "#migration-change", "true")

    view
    |> form("#metar-card-form",
      metar_card: %{
        clerk: "Inés",
        craft: "ATR 72-600",
        visibility_m: "600",
        runway: "27"
      }
    )
    |> render_submit()

    assert has_element?(view, "#written-runway", "27")
    assert Repo.get_by!(GranadaMetarCard, runway: "27").visibility_m == 600
  end

  test "zero visibility is rejected and leaves no row", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#metar-card-form",
      metar_card: %{
        clerk: "Inés",
        craft: "ATR 72-600",
        visibility_m: "0",
        runway: "09"
      }
    )
    |> render_submit()

    refute has_element?(view, "#written-runway")
    assert Repo.aggregate(GranadaMetarCard, :count) == 0
  end
end
