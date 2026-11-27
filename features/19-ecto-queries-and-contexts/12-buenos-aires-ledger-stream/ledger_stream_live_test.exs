defmodule PhoenixMultivitaminWeb.BuenosAiresLedgerStreamLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.BuenosAiresLedgerDesk
  alias PhoenixMultivitamin.BuenosAiresLedgerLine
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/12-buenos-aires-ledger-stream"

  test "stream inside a transaction sums ledger litres", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    for {entry, litres} <- [
          {"uplift bowser 1", 4200},
          {"uplift bowser 2", 3800},
          {"top-off", 200}
        ] do
      {:ok, _} =
        Repo.insert(%BuenosAiresLedgerLine{
          clerk: "Valentina",
          craft: "Boeing 737-800",
          entry: entry,
          litres: litres,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#total-litres", "8200")
  end

  test "Repo.stream outside a transaction raises only when reduced", %{conn: _conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, _} =
      Repo.insert(%BuenosAiresLedgerLine{
        clerk: "Valentina",
        craft: "Boeing 737-800",
        entry: "stray line",
        litres: 10,
        inserted_at: now,
        updated_at: now
      })

    stream = BuenosAiresLedgerDesk.open_litres_stream()
    assert is_function(stream) or match?(%Stream{}, stream)

    assert_raise RuntimeError, ~r/cannot reduce stream outside of transaction/, fn ->
      BuenosAiresLedgerDesk.stream_outside_transaction!()
    end
  end
end
