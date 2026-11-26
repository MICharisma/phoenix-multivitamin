# Auth and scopes · 10 · Concepción Biobío scope
#
# Teaches:
# - sudo_valid?/1 via DateTime.diff within a recent window
# - parse_authenticated_at/1 rebuilds DateTime from an ISO8601 session string

defmodule PhoenixMultivitaminWeb.BiobioSudo do
  @moduledoc false

  alias PhoenixMultivitaminWeb.BiobioScope

  # Master plate drawer stays unlocked for five minutes after authentication.
  @sudo_window_seconds 300

  def sudo_window_seconds, do: @sudo_window_seconds

  def sudo_valid?(%BiobioScope{authenticated_at: %DateTime{} = at}) do
    age = DateTime.diff(DateTime.utc_now(), at, :second)

    cond do
      age < 0 -> false
      age <= @sudo_window_seconds -> true
      true -> false
    end
  end

  def sudo_valid?(_), do: false

  def parse_authenticated_at(iso) when is_binary(iso) do
    case DateTime.from_iso8601(iso) do
      {:ok, dt, _offset} -> {:ok, dt}
      _ -> :error
    end
  end

  def parse_authenticated_at(%DateTime{} = dt), do: {:ok, dt}
  def parse_authenticated_at(_), do: :error
end
