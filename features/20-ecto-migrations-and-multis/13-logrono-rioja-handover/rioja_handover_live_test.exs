defmodule PhoenixMultivitaminWeb.LogronoRiojaHandoverLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.LogronoRiojaBatch
  alias PhoenixMultivitamin.LogronoRiojaNote
  alias PhoenixMultivitamin.Repo

  @path "/features/20-ecto-migrations-and-multis/13-logrono-rioja-handover"

  test "four-step Multi seals the batch and writes the note", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#batch-form", batch: %{batch_code: "RJ-9911", note_body: "harvest night"})
    |> render_submit()

    assert has_element?(view, "#sealed-code", "RJ-9911")
    assert has_element?(view, "#sealed-status", "sealed")
    assert has_element?(view, "#sealed-note", "harvest night")

    batch = Repo.get_by!(LogronoRiojaBatch, batch_code: "RJ-9911")
    assert batch.status == "sealed"
    assert batch.sealed_at

    assert Repo.get_by!(LogronoRiojaNote, logrono_rioja_batch_id: batch.id).body ==
             "harvest night"
  end

  test "duplicate batch_code fails on the :batch step", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#batch-form", batch: %{batch_code: "RJ-4400", note_body: "first seal"})
    |> render_submit()

    assert has_element?(view, "#sealed-code", "RJ-4400")

    view
    |> form("#batch-form", batch: %{batch_code: "RJ-4400", note_body: "second seal"})
    |> render_submit()

    assert has_element?(view, "#failed-step", "batch")
    assert Repo.aggregate(LogronoRiojaBatch, :count) == 1
  end
end
