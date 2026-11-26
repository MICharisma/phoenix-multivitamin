defmodule PhoenixMultivitaminWeb.OostwoldBalloonPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: assign-crew
    # focus: assign(:crew_chief, "Bram")
    conn
    |> assign(:field, "Oostwold balloon meadow")
    |> assign(:balloon, "Cameron balloon Polder Groen")
    |> assign(:crew_chief, "Bram")
    # endregion: assign-crew
    # region: put-private
    # focus: put_private(:launch_code, "polder-green")
    |> put_private(:launch_code, "polder-green")
    |> put_private(:radio_channel, "Eelde balloon net")

    # endregion: put-private
  end
end
