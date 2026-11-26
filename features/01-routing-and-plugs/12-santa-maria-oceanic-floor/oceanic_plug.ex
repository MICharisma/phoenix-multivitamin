defmodule PhoenixMultivitaminWeb.SantaMariaOceanicPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: stamp-oceanic
    # focus: assign(:fir, "Santa Maria Oceanic")
    conn
    |> assign(:fir, "Santa Maria Oceanic")
    |> stamp_trace("oceanic")

    # endregion: stamp-oceanic
  end

  def stamp_trace(conn, step) do
    assign(conn, :pipeline_trace, (conn.assigns[:pipeline_trace] || []) ++ [step])
  end
end
