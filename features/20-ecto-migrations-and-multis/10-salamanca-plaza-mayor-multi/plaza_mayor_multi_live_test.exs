defmodule PhoenixMultivitaminWeb.SalamancaPlazaMayorMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SalamancaPlazaLine
  alias PhoenixMultivitamin.SalamancaPlazaOrder

  @path "/features/20-ecto-migrations-and-multis/10-salamanca-plaza-mayor-multi"

  test "a valid order and line both persist", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#order-form", order: %{stand: "PM-4", part: "tyre", qty: "4"})
    |> render_submit()

    assert has_element?(view, "#placed-stand", "PM-4")
    assert Repo.get_by!(SalamancaPlazaOrder, stand: "PM-4")
    assert Repo.aggregate(SalamancaPlazaLine, :count) == 1
  end

  test "zero qty fails on :line; changes_so_far keeps the order; DB does not", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#order-form", order: %{stand: "PM-9", part: "tyre", qty: "0"})
    |> render_submit()

    assert has_element?(view, "#failed-operation", "line")
    assert has_element?(view, "#order-in-changes", "true")
    assert has_element?(view, "#order-persisted", "false")

    assert Repo.aggregate(SalamancaPlazaOrder, :count) == 0
    assert Repo.aggregate(SalamancaPlazaLine, :count) == 0
  end
end
