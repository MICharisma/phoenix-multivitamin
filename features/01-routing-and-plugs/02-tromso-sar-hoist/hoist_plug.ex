defmodule PhoenixMultivitaminWeb.TromsoSarHoistPlug do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    # region: read-ticket
    # focus: get_req_header(conn, "x-winch-ticket")
    case get_req_header(conn, "x-winch-ticket") do
      # endregion: read-ticket
      # region: assign-crew
      # focus: assign(:winch_operator, "Sigrid")
      ["hoist-17"] ->
        conn
        |> assign(:pad, "Tromsø SAR pad")
        |> assign(:hoist, "Sea King winch 17")
        |> assign(:winch_operator, "Sigrid")

      # endregion: assign-crew

      # region: lock-pad
      # focus: put_status(:unauthorized)
      _ ->
        conn
        |> assign(:page_title, "Tromsø SAR hoist")
        |> assign(:flash, conn.assigns[:flash] || %{})
        |> assign(:pad, "Tromsø SAR pad")
        |> put_status(:unauthorized)
        |> put_view(html: PhoenixMultivitaminWeb.TromsoSarHoistHTML)
        |> render(:locked)
        # endregion: lock-pad
        # region: halt-pad
        # focus: halt()
        |> halt()

        # endregion: halt-pad
    end
  end
end
