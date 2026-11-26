defmodule PhoenixMultivitaminWeb.UshuaiaAustralPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: stamp-austral
    # focus: stamp_trace("austral")
    conn
    |> assign(:austral, "Ushuaia austral")
    |> assign(:nation, "Tierra del Fuego")
    |> stamp_trace("austral")

    # endregion: stamp-austral
  end

  def stamp_trace(conn, step) do
    assign(conn, :pipeline_trace, (conn.assigns[:pipeline_trace] || []) ++ [step])
  end
end
