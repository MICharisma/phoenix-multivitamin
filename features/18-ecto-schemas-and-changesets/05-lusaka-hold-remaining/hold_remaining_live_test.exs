defmodule PhoenixMultivitaminWeb.LusakaHoldRemainingLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.LusakaHoldCard
  alias PhoenixMultivitamin.Repo

  @path "/features/18-ecto-schemas-and-changesets/05-lusaka-hold-remaining"

  test "virtual remaining_min survives insert and is nil after reload", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Chileshe")

    view
    |> form("#hold-card-form", hold_card: %{hold_min: "25", burned_min: "40"})
    |> render_change()

    assert has_element?(view, "#hold-card-form", "cannot exceed the hold")

    view
    |> form("#hold-card-form", hold_card: %{hold_min: "25", burned_min: "8"})
    |> render_submit()

    assert has_element?(view, "#inserted-remaining", "17")
    assert has_element?(view, "#reloaded-remaining", "nil")

    card = Repo.get_by!(LusakaHoldCard, hold_min: 25, burned_min: 8)
    assert card.remaining_min == nil
    assert card.hold_min == 25
  end
end
