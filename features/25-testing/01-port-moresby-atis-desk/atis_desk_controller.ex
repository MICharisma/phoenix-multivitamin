# Testing · 01 · Port Moresby ATIS desk
#
# Teaches:
# - One controller serves HTML through render/3 and JSON through json/2
# - ConnCase get/2 drives both without a browser

defmodule PhoenixMultivitaminWeb.PortMoresbyAtisDeskController do
  @moduledoc false
  use PhoenixMultivitaminWeb, :controller

  @atis %{
    station: "AYPY",
    observer: "Kila",
    information: "Charlie",
    wind: "14012KT",
    visibility: "9999",
    weather: "SHRA",
    cloud: "SCT018 BKN040",
    temperature: "28/24",
    qnh: "1009",
    craft: "Dash 8-200"
  }

  def show(conn, _params) do
    conn
    |> assign(:page_title, "Port Moresby ATIS desk")
    |> assign(:flash, conn.assigns[:flash] || %{})
    |> assign(:atis, @atis)
    |> render(:show)
  end

  def export(conn, _params) do
    json(conn, %{atis: @atis, format: "json"})
  end
end
