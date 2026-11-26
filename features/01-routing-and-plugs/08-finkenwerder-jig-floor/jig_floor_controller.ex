# Routing and plugs · 08 · Finkenwerder jig floor
#
# Teaches:
# - One controller behind :browser and :api pipelines
# - plug :accepts picks html versus json from the Accept header
# - A mismatched Accept raises 406 and never reaches the jig ledger

defmodule PhoenixMultivitaminWeb.FinkenwerderJigFloorController do
  @moduledoc false
  use PhoenixMultivitaminWeb, :controller

  @jigs %{
    "msny-12" => %{station: "wing jig 12", join: "A321neo wingbox", minutes: 90},
    "fuse-4" => %{station: "fuse jig 4", join: "rear section 19", minutes: 75},
    "door-3" => %{station: "door jig 3", join: "pax door C", minutes: 60}
  }

  # region: list-jigs
  # focus: respond(conn, :index, %{jigs: jigs, jig: nil})
  def index(conn, _params) do
    jigs =
      @jigs
      |> Enum.map(fn {id, jig} -> Map.put(jig, :id, id) end)
      |> Enum.sort_by(& &1.id)

    respond(conn, :index, %{jigs: jigs, jig: nil})
  end

  # endregion: list-jigs

  # region: show-jig
  # focus: %{"jig_id" => jig_id}
  def show(conn, %{"jig_id" => jig_id}) do
    jig = Map.put(@jigs[jig_id], :id, jig_id)
    respond(conn, :show, %{jigs: [], jig: jig})
  end

  # endregion: show-jig

  defp respond(conn, template, assigns) do
    # region: pick-format
    # focus: get_format(conn)
    case get_format(conn) do
      "json" ->
        json(conn, json_payload(template, assigns))

      # endregion: pick-format

      # region: render-html
      # focus: render(template)
      _ ->
        conn
        |> assign(:page_title, "Finkenwerder jig floor")
        |> assign(:flash, conn.assigns[:flash] || %{})
        |> assign(:plant, "Airbus Finkenwerder")
        |> assign(:jig_clerk, "Anke")
        |> assign(:jigs, assigns.jigs)
        |> assign(:jig, assigns.jig)
        |> render(template)

        # endregion: render-html
    end
  end

  # region: json-payload
  defp json_payload(:index, %{jigs: jigs}) do
    %{
      plant: "Airbus Finkenwerder",
      jigs: Enum.map(jigs, &jig_payload/1)
    }
  end

  defp json_payload(:show, %{jig: jig}) do
    %{plant: "Airbus Finkenwerder", jig: jig_payload(jig)}
  end

  # endregion: json-payload

  defp jig_payload(jig) do
    %{id: jig.id, station: jig.station, join: jig.join, minutes: jig.minutes}
  end
end
