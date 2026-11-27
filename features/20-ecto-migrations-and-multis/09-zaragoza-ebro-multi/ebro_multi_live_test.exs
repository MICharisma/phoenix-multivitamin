defmodule PhoenixMultivitaminWeb.ZaragozaEbroMultiLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.ZaragozaEbroDraft

  @path "/features/20-ecto-migrations-and-multis/09-zaragoza-ebro-multi"

  test "named steps insert then update the draft to filed", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#draft-form", draft: %{route: "ZAZ-BCN"})
    |> render_submit()

    assert has_element?(view, "#filed-route", "ZAZ-BCN")
    assert has_element?(view, "#filed-status", "filed")
    assert has_element?(view, "#step-names", "file_draft,insert_draft")

    assert Repo.get_by!(ZaragozaEbroDraft, route: "ZAZ-BCN").status == "filed"
  end
end
