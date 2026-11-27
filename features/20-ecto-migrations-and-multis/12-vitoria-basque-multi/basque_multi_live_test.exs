defmodule PhoenixMultivitaminWeb.VitoriaBasqueMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.VitoriaBasqueHandover
  alias PhoenixMultivitamin.VitoriaBasqueReceipt

  @path "/features/20-ecto-migrations-and-multis/12-vitoria-basque-multi"

  test "context Multi returns a String.Chars result and persists both rows", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#handover-form", handover: %{bay: "Sur-5", souls: "42"})
    |> render_submit()

    assert has_element?(view, "#result-line", "Sur-5 · VIT-SUR-42 · 42 souls")

    handover = Repo.get_by!(VitoriaBasqueHandover, bay: "Sur-5")
    assert handover.souls == 42
    assert Repo.get_by!(VitoriaBasqueReceipt, vitoria_basque_handover_id: handover.id)
  end
end
