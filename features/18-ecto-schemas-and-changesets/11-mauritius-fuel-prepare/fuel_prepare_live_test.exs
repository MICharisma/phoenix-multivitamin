defmodule PhoenixMultivitaminWeb.MauritiusFuelPrepareLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.MauritiusFuelTicket
  alias PhoenixMultivitamin.Repo

  @path "/features/18-ecto-schemas-and-changesets/11-mauritius-fuel-prepare"

  test "prepare_changes converts gallons on insert and skips invalid cards", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Priya")

    view
    |> form("#fuel-ticket-form", fuel_ticket: %{litres: "0", unit_hint: "us_gallon"})
    |> render_change()

    assert has_element?(view, "#fuel-ticket-form", "must be greater than 0")
    refute Repo.get_by(MauritiusFuelTicket, unit_hint: "us_gallon")

    view
    |> form("#fuel-ticket-form", fuel_ticket: %{litres: "1000", unit_hint: "us_gallon"})
    |> render_submit()

    assert has_element?(view, "#written-litres", "3785")
    assert Repo.get_by!(MauritiusFuelTicket, litres: 3785).unit_hint == "us_gallon"
  end
end
