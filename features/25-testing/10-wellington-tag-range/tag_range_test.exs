defmodule PhoenixMultivitamin.WellingtonTagRangeTest do
  use ExUnit.Case, async: true

  alias PhoenixMultivitamin.WellingtonRangeLog

  @moduletag :cook_strait

  setup_all do
    {:ok, station: "Wellington International", craft: "Dash 8-300"}
  end

  setup %{craft: craft} = context do
    sector = Map.get(context, :sector, :cook)
    log = craft |> then(fn _ -> WellingtonRangeLog.open!(sector) end)
    {:ok, log: log, craft: craft}
  end

  describe "Cook Strait boarding" do
    @describetag sector: :cook

    test "boards Moana's Dash with souls from setup_all", %{
      log: log,
      craft: craft,
      station: station
    } do
      boarded = WellingtonRangeLog.board(log, craft, 48)
      assert WellingtonRangeLog.label(boarded) == "Cook Strait · Dash 8-300 · 48 souls"
      assert station == "Wellington International"
    end

    @tag souls: 12
    test "a tagged souls count overrides the default boarding", %{
      log: log,
      craft: craft,
      souls: souls
    } do
      boarded = WellingtonRangeLog.board(log, craft, souls)
      assert boarded.souls == 12
      assert boarded.sector == :cook
    end
  end

  describe "Harbour boarding" do
    @describetag sector: :harbour

    test "opens the harbour sector from the describe tag", %{log: log, craft: craft} do
      boarded = WellingtonRangeLog.board(log, craft, 36)
      assert WellingtonRangeLog.label(boarded) == "Harbour · Dash 8-300 · 36 souls"
    end
  end
end
