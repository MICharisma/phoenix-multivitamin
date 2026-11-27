# Ecto schemas and changesets · 04 · Entebbe station watches
#
# Teaches:
# - belongs_to / has_many written through the Repo and reloaded with preload

defmodule PhoenixMultivitaminWeb.EntebbeStationWatchesLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  import Ecto.Query

  alias PhoenixMultivitamin.EntebbeStation
  alias PhoenixMultivitamin.EntebbeWatch
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    station =
      case Repo.get_by(EntebbeStation, icao: "HUEN") do
        nil ->
          {:ok, created} =
            %EntebbeStation{}
            |> EntebbeStation.changeset(%{name: "Entebbe International", icao: "HUEN"})
            |> Repo.insert()

          created

        existing ->
          existing
      end

    {:ok,
     socket
     |> assign_scenario("Entebbe station watches", "Namazzi", "Bombardier CRJ900")
     |> assign(:station, station)
     |> assign(:watch_names, watch_names(station.id))
     |> assign(:form, watch_form(station.id))}
  end

  @impl true
  def handle_event("validate_watch", %{"watch" => params}, socket) do
    changeset =
      %EntebbeWatch{}
      |> EntebbeWatch.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :watch))}
  end

  def handle_event("open_watch", %{"watch" => params}, socket) do
    station = socket.assigns.station

    changeset =
      %EntebbeWatch{}
      |> EntebbeWatch.changeset(Map.put(params, "entebbe_station_id", station.id))

    socket =
      case Repo.insert(changeset) do
        {:ok, _watch} ->
          socket
          |> assign(:watch_names, watch_names(station.id))
          |> assign(:form, watch_form(station.id))

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :watch))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 04 · Entebbe station watches
      </p>

      <h1>Entebbe station watches</h1>
      <p class="lede">
        Clerk {@clerk} opens night watches on the {@craft} station at Entebbe
        through belongs_to and has_many.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="station-icao">{@station.icao}</p>
      <ul id="watch-list">
        <li :for={name <- @watch_names} id={"watch-#{name}"}>{name}</li>
      </ul>

      <.form for={@form} id="watch-form" phx-change="validate_watch" phx-submit="open_watch">
        <.input field={@form[:controller]} label="Controller" />
        <.input field={@form[:window]} label="Window" />
        <.button id="open-watch" type="submit">Open the watch</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp watch_form(station_id) do
    %EntebbeWatch{}
    |> EntebbeWatch.changeset(%{
      "controller" => "Namazzi",
      "window" => "20:00–00:00",
      "entebbe_station_id" => station_id
    })
    |> to_form(as: :watch)
  end

  defp watch_names(station_id) do
    EntebbeStation
    |> where([s], s.id == ^station_id)
    |> preload(:watches)
    |> Repo.one!()
    |> Map.fetch!(:watches)
    |> Enum.map(& &1.controller)
  end
end
