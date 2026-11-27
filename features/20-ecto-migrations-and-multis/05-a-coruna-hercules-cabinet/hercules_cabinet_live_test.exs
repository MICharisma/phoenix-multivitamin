defmodule PhoenixMultivitaminWeb.ACorunaHerculesCabinetLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.ACorunaColumnProbe
  alias PhoenixMultivitamin.ACorunaHerculesCabinet
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/05-a-coruna-hercules-cabinet"

  test "lamp_hours has a default and SQLite refuses NOT NULL without one", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#lamp-default", "0")

    view
    |> form("#cabinet-form", cabinet: %{beacon: "Tower of Hercules", lamp_hours: "40"})
    |> render_submit()

    assert has_element?(view, "#written-beacon", "Tower of Hercules")
    assert Repo.get_by!(ACorunaHerculesCabinet, beacon: "Tower of Hercules").lamp_hours == 40

    render_click(view, "probe_sqlite_limit")
    assert has_element?(view, "#alter-refusal")

    html = render(view)
    assert html =~ "NOT NULL" or html =~ "Cannot add" or html =~ "default"

    assert {:refused, message} =
             ACorunaColumnProbe.try_add_not_null_without_default(
               "coruna_hercules_cabinets",
               "another_forbidden"
             )

    assert message =~ "NOT NULL" or message =~ "default" or message =~ "Cannot add"
  end
end
