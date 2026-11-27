# Mailers with Swoosh · 12 · Kumasi garden mailer
#
# Teaches:
# - Pushing a whole crew roster through deliver_many from the board
# - Showing the station from address that is not noreply@

defmodule PhoenixMultivitaminWeb.KumasiGardenMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.KumasiGardenMailer

  @impl true
  def mount(_params, _session, socket) do
    {station_name, station_address} = KumasiGardenMailer.station_from()

    {:ok,
     socket
     |> assign_scenario("Kumasi garden mailer", "Ama", "Dash 8-400")
     |> assign(:station, "Kumasi · garden tower")
     |> assign(:from_name, station_name)
     |> assign(:from_address, station_address)
     |> assign(:roster_count, 0)
     |> assign(:roles, [])}
  end

  @impl true
  def handle_event("push_crew_roster", _params, socket) do
    {:ok, emails, _meta} =
      KumasiGardenMailer.deliver_crew_roster(socket.assigns.craft, "Garden Stand 3")

    roles =
      emails
      |> Enum.map(& &1.headers["X-Crew-Role"])
      |> Enum.reject(&is_nil/1)

    {:noreply,
     socket
     |> assign(:roster_count, length(emails))
     |> assign(:roles, roles)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 12 · Kumasi garden mailer
      </p>

      <header class="masthead">
        <h1>Kumasi garden mailer</h1>
        <p class="lede">
          Ama's garden tower pushes the whole Dash 8 crew roster through deliver_many,
          from the station address rather than noreply@.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>From name</dt>
        <dd id="from-name">{@from_name}</dd>
        <dt>From address</dt>
        <dd id="from-address">{@from_address}</dd>
        <dt>Roster count</dt>
        <dd id="roster-count">{@roster_count}</dd>
      </dl>

      <ul id="crew-roles" class="scenario">
        <li :for={role <- @roles} id={"role-#{role}"}>{role}</li>
      </ul>

      <div class="watch-actions">
        <button id="push-crew-roster" type="button" phx-click="push_crew_roster">
          Push crew roster
        </button>
      </div>
    </Layouts.app>
    """
  end
end
