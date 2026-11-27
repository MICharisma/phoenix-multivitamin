defmodule PhoenixMultivitaminWeb.TokyoJoinPreloadLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.TokyoAirline
  alias PhoenixMultivitamin.TokyoCrew

  @path "/features/19-ecto-queries-and-contexts/05-tokyo-join-preload"

  test "join-preload exposes airline name on each crew", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, jal} =
      Repo.insert(%TokyoAirline{
        name: "Japan Airlines",
        iata: "JL",
        inserted_at: now,
        updated_at: now
      })

    {:ok, ana} =
      Repo.insert(%TokyoAirline{
        name: "All Nippon Airways",
        iata: "NH",
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%TokyoCrew{
        clerk: "Haruto",
        craft: "Boeing 787-9",
        role: "captain",
        tokyo_airline_id: jal.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%TokyoCrew{
        clerk: "Yui",
        craft: "Boeing 787-9",
        role: "purser",
        tokyo_airline_id: ana.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#crew-count", "2")
    assert has_element?(view, "#tokyo-crews", "Japan Airlines")
    assert has_element?(view, "#tokyo-crews", "All Nippon Airways")
    assert has_element?(view, "#tokyo-crews", "JL")
  end
end
