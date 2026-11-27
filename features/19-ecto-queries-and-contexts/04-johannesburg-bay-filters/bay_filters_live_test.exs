defmodule PhoenixMultivitaminWeb.JohannesburgBayFiltersLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.JohannesburgBayCard
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/04-johannesburg-bay-filters"

  test "dynamic filters narrow bay cards and empty filters show all", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    for {bay, status, defects} <- [
          {"Bay 3", "open", 2},
          {"Bay 3", "closed", 0},
          {"Bay 7", "open", 1}
        ] do
      {:ok, _} =
        Repo.insert(%JohannesburgBayCard{
          clerk: "Thabo",
          craft: "Airbus A320neo",
          bay: bay,
          status: status,
          open_defects: defects,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#card-count", "3")

    view
    |> form("#bay-filter-form", %{bay: "Bay 3", status: "open"})
    |> render_change()

    assert has_element?(view, "#card-count", "1")
    assert has_element?(view, "#bay-cards", "Bay 3")
    assert has_element?(view, "#bay-cards", "open")
    refute has_element?(view, "#bay-cards", "Bay 7")

    view
    |> form("#bay-filter-form", %{bay: "", status: ""})
    |> render_change()

    assert has_element?(view, "#card-count", "3")
  end
end
