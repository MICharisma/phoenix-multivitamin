# Routing and plugs · 07 · Barra beach shed
#
# Teaches:
# - A controller plug that halt/1 skips later plugs and the action
# - Plugs that already ran stay on the conn; later ones never stamp
# - A valid beach pass lets the whole stack, including show/2, finish

defmodule PhoenixMultivitaminWeb.BarraBeachShedController do
  @moduledoc false
  use PhoenixMultivitaminWeb, :controller

  # region: declare-plugs
  # focus: plug :check_beach_pass
  plug :stamp_beach
  plug :check_beach_pass
  plug :stamp_turnstile
  # endregion: declare-plugs

  # region: show-action
  # focus: stamp_trace("show-action")
  def show(conn, _params) do
    conn
    |> assign(:page_title, "Barra beach shed")
    |> assign(:flash, conn.assigns[:flash] || %{})
    |> assign(:slip, "Traigh Mhòr 07")
    |> stamp_trace("show-action")
    |> render(:show)
  end

  # endregion: show-action

  # region: stamp-beach
  # focus: assign(:beach, "Traigh Mhòr")
  defp stamp_beach(conn, _opts) do
    conn
    |> assign(:beach, "Traigh Mhòr")
    |> assign(:marshal, "Eilidh")
    |> stamp_trace("stamp-beach")
  end

  # endregion: stamp-beach

  defp check_beach_pass(conn, _opts) do
    conn = stamp_trace(conn, "check-pass")

    # region: admit-walk-on
    # focus: get_req_header(conn, "x-beach-pass")
    case get_req_header(conn, "x-beach-pass") do
      ["islander-beach"] ->
        assign(conn, :passenger, "walk-on for the Islander")

      # endregion: admit-walk-on

      # region: deny-and-halt
      # focus: halt()
      _ ->
        conn
        |> assign(:page_title, "Barra beach shed")
        |> assign(:flash, conn.assigns[:flash] || %{})
        |> put_status(:forbidden)
        |> render(:denied)
        |> halt()

        # endregion: deny-and-halt
    end
  end

  # region: stamp-turnstile
  # focus: assign(:turnstile, "open onto the beach strip")
  defp stamp_turnstile(conn, _opts) do
    conn
    |> assign(:turnstile, "open onto the beach strip")
    |> stamp_trace("stamp-turnstile")
  end

  # endregion: stamp-turnstile

  defp stamp_trace(conn, step) do
    assign(conn, :pipeline_trace, (conn.assigns[:pipeline_trace] || []) ++ [step])
  end
end
