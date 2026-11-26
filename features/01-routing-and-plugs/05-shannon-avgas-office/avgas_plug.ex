defmodule PhoenixMultivitaminWeb.ShannonAvgasPlug do
  @moduledoc false
  import Plug.Conn

  # region: transform-opts
  # focus: def init(opts)
  def init(opts) do
    %{
      apron: Keyword.fetch!(opts, :apron),
      grade: Keyword.fetch!(opts, :grade),
      bowser: Keyword.fetch!(opts, :bowser)
    }
  end

  # endregion: transform-opts

  # region: receive-map
  # focus: %{apron: apron, grade: grade, bowser: bowser}
  def call(conn, %{apron: apron, grade: grade, bowser: bowser}) do
    conn
    |> assign(:apron, apron)
    |> assign(:grade, grade)
    |> assign(:bowser, bowser)
    |> assign(:clerk, "Orla")
    |> assign(:init_keys, "apron grade bowser")
  end

  # endregion: receive-map
end
