defmodule PhoenixMultivitaminWeb.MaheNotamDraftLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/12-mahe-notam-draft"

  test "schemaless changeset files a map draft and refuses a short body", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Liz")

    view
    |> form("#notam-draft-form", notam_draft: %{body: "birds"})
    |> render_change()

    assert has_element?(view, "#notam-draft-form", "should be at least 12 character")

    view
    |> form("#notam-draft-form", %{
      notam_draft: %{
        icao: "FSIA",
        body: "Bird activity near threshold 13",
        valid_hours: "6"
      }
    })
    |> render_submit()

    assert has_element?(view, "#draft-icao", "FSIA")
    assert has_element?(view, "#draft-is-map", "map")
  end
end
