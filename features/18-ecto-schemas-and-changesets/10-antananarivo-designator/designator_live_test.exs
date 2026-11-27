defmodule PhoenixMultivitaminWeb.AntananarivoDesignatorLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.AntananarivoDesignator
  alias PhoenixMultivitamin.Repo

  @path "/features/18-ecto-schemas-and-changesets/10-antananarivo-designator"

  test "unique_constraint blocks a second MDG441 only after insert", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Voahangy")

    view
    |> form("#designator-form", designator: %{callsign: "MDG441"})
    |> render_change()

    refute has_element?(view, "#designator-form", "has already been taken")

    view
    |> form("#designator-form", designator: %{callsign: "MDG441"})
    |> render_submit()

    assert has_element?(view, "#written-callsign", "MDG441")
    assert Repo.get_by!(AntananarivoDesignator, callsign: "MDG441")

    view
    |> form("#designator-form", designator: %{callsign: "MDG441"})
    |> render_submit()

    assert has_element?(view, "#duplicate-blocked", "duplicate blocked")
    assert has_element?(view, "#designator-form", "has already been taken")
  end
end
