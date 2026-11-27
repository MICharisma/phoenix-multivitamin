# Gettext translations · 07 · Oslo extract hangar
#
# Teaches:
# - gettext macros leave extractable msgids for mix gettext.extract --merge
# - The .pot lists msgids; the .po holds Norwegian msgstr after merge
# - A defstruct hangar plate carries the domain values the board prints

defmodule PhoenixMultivitaminWeb.OsloExtractHangarLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.OsloGettext

  alias PhoenixMultivitaminWeb.OsloHangarPlate

  @extracted_msgids [
    "Hangar bay clear",
    "Plate stamped for inspection"
  ]

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.OsloGettext, "nb")
    plate = OsloHangarPlate.new("LN-NIE", "Bay 3")

    {:ok,
     socket
     |> assign_scenario("Oslo extract hangar", "Ingrid", "737-800")
     |> assign(:page_title, "Oslo extract hangar")
     |> assign(:station, "Oslo Gardermoen")
     |> assign(:airline, "Norwegian")
     |> assign(:plate, plate)
     |> assign(:extracted_msgids, @extracted_msgids)
     |> assign(:bay_line, gettext("Hangar bay clear"))
     |> assign(:stamp_line, nil)}
  end

  @impl true
  def handle_event("stamp_plate", _params, socket) do
    {:noreply, assign(socket, :stamp_line, gettext("Plate stamped for inspection"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 07 · Oslo extract hangar
      </p>

      <h1>Oslo extract hangar</h1>
      <p class="lede">
        Clerk {@clerk} stamps Norwegian 737 plates at {@station}. The <code>gettext/1</code>
        macros in this module are what <code>mix gettext.extract --merge</code>
        harvests into the scenario <code>.pot</code>
        and merges into <code>.po</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="plate-tail">{@plate.tail}</p>
      <p id="plate-bay">{@plate.bay}</p>
      <p id="bay-line">{@bay_line}</p>

      <ul id="extracted-msgids">
        <li :for={msgid <- @extracted_msgids} id={"msgid-#{msgid}"}>{msgid}</li>
      </ul>

      <button id="stamp-plate" type="button" phx-click="stamp_plate">
        Stamp plate
      </button>
      <p :if={@stamp_line} id="stamp-line">{@stamp_line}</p>
    </Layouts.app>
    """
  end
end
