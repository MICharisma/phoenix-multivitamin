defmodule PhoenixMultivitamin.AucklandLogVaultTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  alias PhoenixMultivitamin.AucklandLogVault
  alias PhoenixMultivitamin.AucklandMetarClient

  setup do
    previous = Application.get_env(:phoenix_multivitamin, :auckland_metar_client)

    Application.put_env(
      :phoenix_multivitamin,
      :auckland_metar_client,
      AucklandMetarClient.Fake
    )

    on_exit(fn ->
      if previous do
        Application.put_env(:phoenix_multivitamin, :auckland_metar_client, previous)
      else
        Application.delete_env(:phoenix_multivitamin, :auckland_metar_client)
      end
    end)

    :ok
  end

  @tag :tmp_dir
  test "archives NZAA under tmp_dir through the fake client", %{tmp_dir: directory} do
    assert {:ok, path} = AucklandLogVault.archive("NZAA", directory)
    assert path == Path.join(directory, "NZAA.json")

    body = path |> File.read!() |> Jason.decode!()
    assert body["station"] == "NZAA"
    assert body["observer"] == "Mere"
    assert body["wind"] == "24012KT"
  end

  @tag :tmp_dir
  test "CaptureLog locks the warning when the station is unknown", %{tmp_dir: directory} do
    log =
      capture_log(fn ->
        assert {:error, {:unknown_station, "NZWN"}} =
                 AucklandLogVault.archive("NZWN", directory)
      end)

    assert log =~ "Waitematā vault refused NZWN"
    assert log =~ "unknown_station"
    refute File.exists?(Path.join(directory, "NZWN.json"))
  end

  @tag :tmp_dir
  test "CaptureLog stays empty for the info line under logger level :warning", %{
    tmp_dir: directory
  } do
    log =
      capture_log(fn ->
        assert {:ok, _path} = AucklandLogVault.archive("NZAA", directory)
      end)

    refute log =~ "archived Waitematā METAR"
    assert log == ""
  end
end
