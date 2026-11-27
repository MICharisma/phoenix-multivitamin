defmodule PhoenixMultivitaminWeb.AucklandLogVaultLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.AucklandMetarClient

  @path "/features/25-testing/13-auckland-log-vault"

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

  test "archiving NZAA paints the vault path", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Mere")

    view |> element("#archive-nzaa") |> render_click()
    assert has_element?(view, "#archive-path", "NZAA.json")
  end
end
