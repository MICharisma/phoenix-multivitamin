defmodule PhoenixMultivitaminWeb.JohannesburgTurnaroundCrewLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.JohannesburgTurnaround
  alias PhoenixMultivitamin.Repo

  @path "/features/18-ecto-schemas-and-changesets/08-johannesburg-turnaround-crew"

  test "cast_assoc writes nested crew legs with the turnaround", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Sipho")

    view
    |> form("#turnaround-form", %{
      turnaround: %{
        stand: "B4",
        crew_legs: %{"0" => %{role: "purser", name: "Lindiwe"}}
      }
    })
    |> render_change()

    assert has_element?(view, "#turnaround-form", "is invalid")

    view
    |> form("#turnaround-form", %{
      turnaround: %{
        stand: "B4",
        crew_legs: %{"0" => %{role: "captain", name: "Lindiwe"}}
      }
    })
    |> render_submit()

    assert has_element?(view, "#crew-Lindiwe", "Lindiwe")

    turnaround = Repo.get_by!(JohannesburgTurnaround, stand: "B4") |> Repo.preload(:crew_legs)
    assert hd(turnaround.crew_legs).name == "Lindiwe"
  end
end
