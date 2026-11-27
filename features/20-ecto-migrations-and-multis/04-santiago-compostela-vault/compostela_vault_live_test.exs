defmodule PhoenixMultivitaminWeb.SantiagoCompostelaVaultLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantiagoSqliteConstraintProbe
  alias PhoenixMultivitamin.SantiagoVaultTicket

  @path "/features/20-ecto-migrations-and-multis/04-santiago-compostela-vault"

  test "duplicate vault_code is blocked only after the first insert", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#vault-form", vault_ticket: %{vault_code: "SCQ-900", litres: "5000"})
    |> render_submit()

    assert has_element?(view, "#written-code", "SCQ-900")
    assert Repo.get_by!(SantiagoVaultTicket, vault_code: "SCQ-900")

    view
    |> form("#vault-form", vault_ticket: %{vault_code: "SCQ-900", litres: "5000"})
    |> render_submit()

    assert has_element?(view, "#block-reason", "duplicate_vault")
    assert Repo.aggregate(SantiagoVaultTicket, :count) == 1
  end

  test "zero litres is rejected and SQLite refuses ADD CONSTRAINT", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view
    |> form("#vault-form", vault_ticket: %{vault_code: "SCQ-001", litres: "0"})
    |> render_submit()

    assert has_element?(view, "#block-reason", "litres_not_positive")
    assert Repo.aggregate(SantiagoVaultTicket, :count) == 0

    render_click(view, "probe_check_constraint")
    assert has_element?(view, "#constraint-refusal")

    assert {:refused, message} = SantiagoSqliteConstraintProbe.try_add_check_constraint()
    assert message =~ "SQLite3 does not support ALTER TABLE ADD CONSTRAINT"
  end
end
