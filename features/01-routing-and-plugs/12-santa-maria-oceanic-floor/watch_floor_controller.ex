# Routing and plugs · 12 · Santa Maria oceanic floor
#
# Teaches:
# - Nested scopes concatenate path prefixes: /station/:station/watch/:watch/floor
# - Nested pipe_through is additive: the child still runs the parent plugs
# - A sibling scope does not inherit a cousin's pipeline
# - Scope path params arrive as strings

defmodule PhoenixMultivitaminWeb.SantaMariaOceanicFloorController do
  @moduledoc false
  use PhoenixMultivitaminWeb, :controller

  # region: scope-params
  # focus: %{"station" => station, "watch" => watch}
  def show(conn, %{"station" => station, "watch" => watch}) do
    # endregion: scope-params
    conn
    |> assign(:page_title, "Santa Maria oceanic floor")
    |> assign(:flash, conn.assigns[:flash] || %{})
    # region: string-params
    # focus: is_binary(station)
    |> assign(:station, station)
    |> assign(:watch, watch)
    |> assign(:station_is_binary, is_binary(station))
    |> assign(:watch_is_binary, is_binary(watch))
    # endregion: string-params
    |> assign(:operator, operator_for(station))
    |> assign(:board, "nested")
    |> render(:show)
  end

  def relief(conn, _params) do
    conn
    |> assign(:page_title, "Santa Maria oceanic floor")
    |> assign(:flash, conn.assigns[:flash] || %{})
    |> assign(:station, "relief radio")
    |> assign(:watch, "none")
    |> assign(:station_is_binary, true)
    |> assign(:watch_is_binary, true)
    |> assign(:operator, "spare radio")
    # region: relief-fir
    # focus: conn.assigns[:fir] || "not on this scope"
    |> assign(:fir, conn.assigns[:fir] || "not on this scope")
    # endregion: relief-fir
    |> assign(:board, "relief")
    |> render(:show)
  end

  defp operator_for("santa-maria"), do: "Duarte"
  defp operator_for("lajes"), do: "Inês"
  defp operator_for(_station), do: "the spare radio"
end
