defmodule PhoenixMultivitaminWeb.EntebbeStationWatchesLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.EntebbeStation
  alias PhoenixMultivitamin.Repo

  @path "/features/18-ecto-schemas-and-changesets/04-entebbe-station-watches"

  test "belongs_to watch lands under the station has_many", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#station-icao", "HUEN")
    assert has_element?(view, "#clerk-name", "Namazzi")

    view
    |> form("#watch-form", watch: %{controller: "Kato", window: "00:00–04:00"})
    |> render_submit()

    assert has_element?(view, "#watch-Kato", "Kato")

    station = Repo.get_by!(EntebbeStation, icao: "HUEN") |> Repo.preload(:watches)
    assert Enum.any?(station.watches, &(&1.controller == "Kato"))
  end
end
