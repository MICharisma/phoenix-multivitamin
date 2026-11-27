defmodule PhoenixMultivitamin.DunedinFuelLedgerTest do
  use PhoenixMultivitamin.DataCase, async: false

  alias PhoenixMultivitamin.DunedinFuelEntry
  alias PhoenixMultivitamin.DunedinFuelLedger
  alias PhoenixMultivitamin.Repo

  describe "sandbox posts" do
    test "post_entry writes through the ledger and rolls back after the test" do
      assert {:ok, entry} =
               DunedinFuelLedger.post_entry(%{
                 clerk: "Hamish",
                 craft: "ATR 72",
                 litres: 2_400,
                 bay: "otago"
               })

      assert entry.bay == "otago"
      assert Repo.get!(DunedinFuelEntry, entry.id).litres == 2_400
      assert DunedinFuelLedger.litres_by_bay() == %{"otago" => 2_400}
    end

    test "a second test does not see the first post" do
      assert DunedinFuelLedger.litres_by_bay() == %{}
      assert Repo.aggregate(DunedinFuelEntry, :count) == 0
    end
  end
end

defmodule PhoenixMultivitamin.DunedinFuelLedgerAsyncTest do
  use ExUnit.Case, async: true

  alias PhoenixMultivitamin.DunedinFuelEntry
  alias PhoenixMultivitamin.DunedinFuelLedger

  test "async cases can total in-memory entries without opening the sandbox" do
    entries = [
      %DunedinFuelEntry{litres: 1_200, bay: "harbour"},
      %DunedinFuelEntry{litres: 800, bay: "otago"}
    ]

    assert DunedinFuelLedger.total_litres(entries) == 2_000
  end
end
