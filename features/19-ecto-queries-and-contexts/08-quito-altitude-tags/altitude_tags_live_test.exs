defmodule PhoenixMultivitaminWeb.QuitoAltitudeTagsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.QuitoCargoTag
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/08-quito-altitude-tags"

  test "SQLite lower fragment matches mixed-case labels and builds display", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, _} =
      Repo.insert(%QuitoCargoTag{
        clerk: "Lucía",
        craft: "Boeing 767-300F",
        label: "Oxygen",
        altitude_ft: 9200,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%QuitoCargoTag{
        clerk: "Lucía",
        craft: "Boeing 767-300F",
        label: "flowers",
        altitude_ft: 9200,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#tag-count", "1")
    assert has_element?(view, "#altitude-tags", "Oxygen @ 9200 ft")
    refute has_element?(view, "#altitude-tags", "flowers")
  end
end
