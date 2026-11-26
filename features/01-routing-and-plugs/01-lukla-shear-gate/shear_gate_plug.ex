defmodule PhoenixMultivitaminWeb.LuklaShearPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: name-approach
    # focus: assign(:approach, "Khumbu approach")
    conn
    |> assign(:approach, "Khumbu approach")
    |> assign(:gate, "Lukla shear gate")
    |> stamp_trace("approach-pipeline")

    # endregion: name-approach
  end

  # region: stamp-trace
  def stamp_trace(conn, step) do
    assign(conn, :pipeline_trace, (conn.assigns[:pipeline_trace] || []) ++ [step])
  end

  # endregion: stamp-trace
end
