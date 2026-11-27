defmodule PhoenixMultivitaminWeb.DubaiCargoHoldsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.DubaiCargoHold
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/02-dubai-cargo-holds"

  test "pipe syntax lists sealed holds ordered by hold code", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    for {code, kg, sealed} <- [{"C", 1200, true}, {"A", 800, true}, {"B", 400, false}] do
      {:ok, _} =
        Repo.insert(%DubaiCargoHold{
          clerk: "Amira",
          craft: "Boeing 777F",
          hold_code: code,
          kilograms: kg,
          sealed: sealed,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#sealed-count", "2")
    assert has_element?(view, "#sealed-holds", "A")
    assert has_element?(view, "#sealed-holds", "C")
    refute has_element?(view, "#sealed-holds", "B")

    html = render(view)
    a_at = :binary.match(html, ">A<") |> elem(0)
    c_at = :binary.match(html, ">C<") |> elem(0)
    assert a_at < c_at
  end
end
