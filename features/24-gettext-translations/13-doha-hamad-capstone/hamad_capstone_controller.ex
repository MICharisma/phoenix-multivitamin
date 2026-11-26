# Gettext translations · 13 · Doha Hamad capstone
#
# Teaches:
# - A locale plug resolves params, then session, then Accept-Language
# - Arabic ngettext covers six plural forms for bag counts
# - Ecto changeset errors translate through the errors domain

defmodule PhoenixMultivitaminWeb.DohaHamadCapstoneController do
  use PhoenixMultivitaminWeb, :controller
  use Gettext, backend: PhoenixMultivitaminWeb.DohaGettext

  alias PhoenixMultivitaminWeb.DohaLoadSheet

  def show(conn, params) do
    bags = parse_bags(params)
    sheet = %DohaLoadSheet{}
    changeset = DohaLoadSheet.changeset(sheet, params["sheet"] || %{})

    bag_line =
      ngettext("1 bag on the belt", "%{count} bags on the belt", bags)

    conn
    |> assign(:page_title, "Doha Hamad capstone")
    |> assign(:clerk, "Noor")
    |> assign(:craft, "A350-1000")
    |> assign(:station, "Hamad International")
    |> assign(:airline, "Qatar Airways")
    |> assign(:bags, bags)
    |> assign(:bag_line, bag_line)
    |> assign(:gate_line, dgettext("gates", "Gate ready for boarding"))
    |> assign(:changeset, changeset)
    |> assign(:error_lines, DohaLoadSheet.translate_errors(changeset))
    |> render(:show)
  end

  defp parse_bags(%{"bags" => bags}) when is_binary(bags) do
    case Integer.parse(bags) do
      {n, _} when n >= 0 -> n
      _ -> 0
    end
  end

  defp parse_bags(_), do: 0
end
