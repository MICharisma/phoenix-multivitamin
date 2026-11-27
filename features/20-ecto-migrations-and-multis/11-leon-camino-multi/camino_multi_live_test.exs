defmodule PhoenixMultivitaminWeb.LeonCaminoMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.LeonCaminoLeg
  alias PhoenixMultivitamin.LeonCaminoStamp
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/11-leon-camino-multi"

  test "merged Multis write the leg and the stamp together", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#walk-form", walk: %{from_icao: "LEN", to_icao: "BIO", stamp: "cruz_de_ferro"})
    |> render_submit()

    assert has_element?(view, "#walked-from", "LEN")
    assert has_element?(view, "#walked-stamp", "cruz_de_ferro")

    leg = Repo.get_by!(LeonCaminoLeg, from_icao: "LEN", to_icao: "BIO")
    assert Repo.get_by!(LeonCaminoStamp, leon_camino_leg_id: leg.id).stamp == "cruz_de_ferro"
  end
end
