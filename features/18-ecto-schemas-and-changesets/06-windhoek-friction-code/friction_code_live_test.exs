defmodule PhoenixMultivitaminWeb.WindhoekFrictionCodeLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.WindhoekFrictionReading

  @path "/features/18-ecto-schemas-and-changesets/06-windhoek-friction-code"

  test "custom type casts GOOD and rejects ICE", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Ndapewa")

    view
    |> form("#friction-form", friction_reading: %{friction: "ICE"})
    |> render_change()

    assert has_element?(view, "#friction-form", "is invalid")

    view
    |> form("#friction-form", friction_reading: %{friction: "medium", runway: "26"})
    |> render_submit()

    assert has_element?(view, "#stored-friction", "MEDIUM")
    assert Repo.get_by!(WindhoekFrictionReading, runway: "26").friction == "MEDIUM"
  end
end
