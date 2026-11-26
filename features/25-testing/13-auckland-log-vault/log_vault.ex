# Testing · 13 · Auckland log vault
#
# Teaches:
# - Logger.warning/1 is what CaptureLog asserts
# - File writes land under the ExUnit :tmp_dir tag

defmodule PhoenixMultivitamin.AucklandLogVault do
  @moduledoc false
  require Logger

  alias PhoenixMultivitamin.AucklandMetarClient

  def archive(station, directory) when is_binary(station) and is_binary(directory) do
    File.mkdir_p!(directory)

    case AucklandMetarClient.fetch(station) do
      {:ok, metar} ->
        path = Path.join(directory, "#{station}.json")
        File.write!(path, Jason.encode!(metar))
        Logger.info("archived Waitematā METAR for #{station}")
        {:ok, path}

      {:error, reason} ->
        Logger.warning("Waitematā vault refused #{station}: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
