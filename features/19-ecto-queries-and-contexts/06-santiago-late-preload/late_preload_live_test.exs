defmodule PhoenixMultivitaminWeb.SantiagoLatePreloadLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantiagoAirline
  alias PhoenixMultivitamin.SantiagoManifest

  @path "/features/19-ecto-queries-and-contexts/06-santiago-late-preload"

  test "late preload fills airline after the manifest fetch", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, lan} =
      Repo.insert(%SantiagoAirline{
        name: "LATAM Cargo",
        iata: "UC",
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%SantiagoManifest{
        clerk: "Camila",
        craft: "Airbus A330-200F",
        awb: "045-81234567",
        kilograms: 2400,
        santiago_airline_id: lan.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, _} =
      Repo.insert(%SantiagoManifest{
        clerk: "Camila",
        craft: "Airbus A330-200F",
        awb: "045-81239999",
        kilograms: 900,
        santiago_airline_id: lan.id,
        inserted_at: now,
        updated_at: now
      })

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#manifest-count", "2")
    assert has_element?(view, "#santiago-manifests", "LATAM Cargo")
    assert has_element?(view, "#santiago-manifests", "045-81234567")
  end
end
