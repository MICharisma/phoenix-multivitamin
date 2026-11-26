defmodule PhoenixMultivitaminWeb.KirunaDeicePlug do
  @moduledoc false
  import Plug.Conn

  # region: init-map
  # focus: System.unique_integer([:monotonic])
  def init(opts) do
    %{
      pads: Keyword.fetch!(opts, :pads),
      compiled_at: System.unique_integer([:monotonic])
    }
  end

  # endregion: init-map

  # region: call-stamp
  # focus: assign(:plug_called_at, System.unique_integer([:monotonic]))
  def call(conn, %{pads: pads, compiled_at: compiled_at}) do
    conn
    |> assign(:pads, pads)
    |> assign(:plug_compiled_at, compiled_at)
    |> assign(:plug_called_at, System.unique_integer([:monotonic]))
    # endregion: call-stamp
    |> assign(:pad, "Kiruna de-ice pad")
    |> assign(:pad_lead, "Astrid")
  end
end
