# Testing · 11 · Rotorua QNH
#
# Teaches:
# - @doc examples become ExUnit doctests
# - Guards and multiple heads keep the steam-field QNH honest

defmodule PhoenixMultivitamin.RotoruaQnh do
  @moduledoc """
  Converts steam-field altimeter readings at Rotorua.
  """

  @type hectopascal :: pos_integer()

  @doc """
  Parses a QNH string from the steam ATIS.

      iex> PhoenixMultivitamin.RotoruaQnh.parse("1013")
      {:ok, 1013}

      iex> PhoenixMultivitamin.RotoruaQnh.parse("890")
      {:error, :below_floor}

      iex> PhoenixMultivitamin.RotoruaQnh.parse("steam")
      {:error, :not_numeric}
  """
  @spec parse(String.t()) :: {:ok, hectopascal()} | {:error, atom()}
  def parse(raw) when is_binary(raw) do
    case Integer.parse(raw) do
      {qnh, ""} when qnh in 900..1080 -> {:ok, qnh}
      {_qnh, ""} -> {:error, :below_floor}
      :error -> {:error, :not_numeric}
      {_qnh, _rest} -> {:error, :not_numeric}
    end
  end

  @doc """
  Labels a QNH for the steam board.

      iex> PhoenixMultivitamin.RotoruaQnh.label(1013)
      "QNH 1013 · steam field"

      iex> PhoenixMultivitamin.RotoruaQnh.label(980)
      "QNH 980 · low steam"
  """
  @spec label(hectopascal()) :: String.t()
  def label(qnh) when is_integer(qnh) and qnh < 1000, do: "QNH #{qnh} · low steam"
  def label(qnh) when is_integer(qnh), do: "QNH #{qnh} · steam field"

  @doc """
  Drops hectopascals when the craft climbs away from the steam.

      iex> PhoenixMultivitamin.RotoruaQnh.delta(1013, 1005)
      8
  """
  @spec delta(hectopascal(), hectopascal()) :: non_neg_integer()
  def delta(from, to) when is_integer(from) and is_integer(to) do
    abs(from - to)
  end
end
