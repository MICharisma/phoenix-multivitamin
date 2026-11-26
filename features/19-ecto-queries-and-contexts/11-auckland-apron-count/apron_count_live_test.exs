defmodule PhoenixMultivitaminWeb.AucklandApronCountLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.AucklandApronStand
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/11-auckland-apron-count"

  test "Repo.aggregate counts occupied and free stands", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    for {stand, occupied} <- [
          {"A1", true},
          {"A2", true},
          {"B1", false},
          {"B2", false},
          {"B3", false}
        ] do
      {:ok, _} =
        Repo.insert(%AucklandApronStand{
          clerk: "Mere",
          craft: "ATR 72-500",
          stand: stand,
          occupied: occupied,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#occupied-count", "2")
    assert has_element?(view, "#free-count", "3")
  end

  test "empty apron aggregates to zero, not nil", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#occupied-count", "0")
    assert has_element?(view, "#free-count", "0")
  end
end
