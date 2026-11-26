defmodule PhoenixMultivitaminWeb.IncheonInspectorPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  # region: read-lane
  # focus: Keyword.fetch!(opts, :lane)
  def call(conn, opts) do
    lane = Keyword.fetch!(opts, :lane)

    conn
    |> assign(:lane, lane)
    # endregion: read-lane
    |> assign(:shed, "Incheon bonded shed")
    |> assign(:inspector, "Haneul")
  end
end
