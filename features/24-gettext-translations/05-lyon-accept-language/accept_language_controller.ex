# Gettext translations · 05 · Lyon Accept-Language
#
# Teaches:
# - A locale plug reads Accept-Language before the action
# - Gettext.put_locale/2 in the plug stamps the process for the request
# - The controller renders the translated ATIS line from that locale

defmodule PhoenixMultivitaminWeb.LyonAcceptLanguageController do
  use PhoenixMultivitaminWeb, :controller
  use Gettext, backend: PhoenixMultivitaminWeb.LyonGettext

  def show(conn, _params) do
    conn
    |> assign(:page_title, "Lyon Accept-Language")
    |> assign(:clerk, "Camille")
    |> assign(:craft, "A320neo")
    |> assign(:station, "Lyon–Saint-Exupéry")
    |> assign(:airline, "Air France")
    |> assign(:atis_line, gettext("ATIS information Alpha available"))
    |> render(:show)
  end
end
