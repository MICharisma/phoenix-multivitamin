# Routing and plugs · 09 · Oostwold balloon line
#
# Teaches:
# - assign/3 values are in conn.assigns and therefore in the template
# - put_private/3 values are on conn.private and are not template assigns
# - The action can still read private fields and copy them if the board must show them

defmodule PhoenixMultivitaminWeb.OostwoldBalloonLineController do
  @moduledoc false
  use PhoenixMultivitaminWeb, :controller

  def show(conn, _params) do
    # region: list-private
    # focus: conn.private |> Map.keys()
    private_keys = conn.private |> Map.keys() |> Enum.map(&to_string/1) |> Enum.sort()
    # endregion: list-private

    conn
    |> assign(:page_title, "Oostwold balloon line")
    |> assign(:flash, conn.assigns[:flash] || %{})
    # region: copy-private
    # focus: conn.private[:launch_code]
    |> assign(:launch_code_private, conn.private[:launch_code])
    |> assign(:radio_channel_private, conn.private[:radio_channel])
    # endregion: copy-private
    # region: missing-assign
    # focus: conn.assigns[:launch_code]
    |> assign(:launch_code_assign, conn.assigns[:launch_code])
    # endregion: missing-assign
    |> assign(:private_key_names, Enum.join(private_keys, " "))
    |> render(:show)
  end
end
