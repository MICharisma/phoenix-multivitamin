defmodule PhoenixMultivitaminWeb.ReykjavikCrewBoardLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.ReykjavikCrewAssignment
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/01-reykjavik-crew-board"

  test "keyword context lists only posted assignments ordered by role", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, _} =
      Repo.insert(%ReykjavikCrewAssignment{
        clerk: "Birna",
        craft: "Boeing 757-200",
        role: "purser",
        posted: true,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%ReykjavikCrewAssignment{
        clerk: "Ólafur",
        craft: "Boeing 757-200",
        role: "captain",
        posted: true,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%ReykjavikCrewAssignment{
        clerk: "Katrín",
        craft: "Boeing 757-200",
        role: "first officer",
        posted: false,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#clerk-name", "Sigríður")
    assert has_element?(view, "#posted-count", "2")
    assert has_element?(view, "#posted-assignments li", "captain")
    assert has_element?(view, "#posted-assignments li", "purser")
    refute has_element?(view, "#posted-assignments", "Katrín")

    html = render(view)
    captain_at = :binary.match(html, "captain") |> elem(0)
    purser_at = :binary.match(html, "purser") |> elem(0)
    assert captain_at < purser_at
  end
end
