defmodule PhoenixMultivitamin.RotoruaQnhTest do
  use ExUnit.Case, async: true

  doctest PhoenixMultivitamin.RotoruaQnh

  alias PhoenixMultivitamin.RotoruaQnh

  test "delta rejects a climb that is not numeric" do
    assert_raise FunctionClauseError, fn ->
      apply(RotoruaQnh, :delta, ["1013", 1005])
    end
  end
end
