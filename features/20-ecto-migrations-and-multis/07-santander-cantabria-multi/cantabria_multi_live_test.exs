defmodule PhoenixMultivitaminWeb.SantanderCantabriaMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantanderFuelSlip
  alias PhoenixMultivitamin.SantanderManifest

  @path "/features/20-ecto-migrations-and-multis/07-santander-cantabria-multi"

  test "both inserts land from one multi", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#pair-form", pair: %{destination: "LCG", litres: "5400"})
    |> render_submit()

    assert has_element?(view, "#filed-destination", "LCG")
    assert has_element?(view, "#filed-litres", "5400")

    manifest = Repo.get_by!(SantanderManifest, destination: "LCG")
    assert Repo.get_by!(SantanderFuelSlip, santander_manifest_id: manifest.id).litres == 5400
  end

  test "zero litres rolls the manifest back", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#pair-form", pair: %{destination: "SDR", litres: "0"})
    |> render_submit()

    refute has_element?(view, "#filed-destination")
    assert Repo.aggregate(SantanderManifest, :count) == 0
    assert Repo.aggregate(SantanderFuelSlip, :count) == 0
  end
end
