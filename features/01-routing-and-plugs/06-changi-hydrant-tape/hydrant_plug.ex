defmodule PhoenixMultivitaminWeb.ChangiHydrantPlug do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: pick-shift
    # focus: conn.params["shift"] || header_shift(conn)
    shift =
      case conn.params["shift"] || header_shift(conn) do
        "day" -> "day"
        "swing" -> "swing"
        _ -> "graveyard"
      end

    # endregion: pick-shift

    # region: assign-shift
    # focus: assign(:shift, shift)
    conn
    |> assign(:shift, shift)
    |> assign(:hydrant, "Changi hydrant pit 12")
    |> assign(:apron, "taxiway N")

    # endregion: assign-shift
  end

  defp header_shift(conn) do
    case get_req_header(conn, "x-hydrant-shift") do
      [shift] -> shift
      _ -> nil
    end
  end
end
