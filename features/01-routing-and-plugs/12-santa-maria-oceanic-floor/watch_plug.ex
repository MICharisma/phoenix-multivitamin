defmodule PhoenixMultivitaminWeb.SantaMariaWatchPlug do
  @moduledoc false
  import Plug.Conn

  alias PhoenixMultivitaminWeb.SantaMariaOceanicPlug

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: stamp-watch
    # focus: SantaMariaOceanicPlug.stamp_trace("watch")
    conn
    |> assign(:watch_plug, "watch floor")
    |> SantaMariaOceanicPlug.stamp_trace("watch")

    # endregion: stamp-watch
  end
end
