defmodule PhoenixMultivitaminWeb.HelsinkiOverdueCardsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.HelsinkiAircraft
  alias PhoenixMultivitamin.HelsinkiWorkCard
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/07-helsinki-overdue-cards"

  test "exists subquery keeps only aircraft with overdue cards", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, overdue_tail} =
      Repo.insert(%HelsinkiAircraft{
        registration: "OH-ATF",
        craft: "ATR 72-600",
        inserted_at: now,
        updated_at: now
      })

    {:ok, clean_tail} =
      Repo.insert(%HelsinkiAircraft{
        registration: "OH-ATG",
        craft: "ATR 72-600",
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%HelsinkiWorkCard{
        title: "Prop de-ice boot",
        overdue: true,
        helsinki_aircraft_id: overdue_tail.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%HelsinkiWorkCard{
        title: "Cabin light",
        overdue: false,
        helsinki_aircraft_id: clean_tail.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#aircraft-count", "1")
    assert has_element?(view, "#overdue-aircraft", "OH-ATF")
    assert has_element?(view, "#overdue-aircraft", "Prop de-ice boot")
    refute has_element?(view, "#overdue-aircraft", "OH-ATG")
  end
end
