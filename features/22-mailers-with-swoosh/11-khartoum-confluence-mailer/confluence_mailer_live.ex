# Mailers with Swoosh · 11 · Khartoum confluence mailer
#
# Teaches:
# - Sharing one ~p board path between the LiveView and the mailer
# - Displaying custom headers after a confluence leg is relayed

defmodule PhoenixMultivitaminWeb.KhartoumConfluenceMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.KhartoumConfluenceMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Khartoum confluence mailer", "Samira", "Boeing 737-800")
     |> assign(:station, "Khartoum · Blue and White Nile confluence")
     |> assign(:board_url, KhartoumConfluenceMailer.board_url())
     |> assign(:flight_leg_header, nil)
     |> assign(:last_subject, nil)}
  end

  @impl true
  def handle_event("relay_leg", _params, socket) do
    {:ok, email} =
      KhartoumConfluenceMailer.deliver_leg_notice(
        socket.assigns.clerk,
        socket.assigns.craft,
        "KRT-NILE-17"
      )

    {:noreply,
     socket
     |> assign(:last_subject, email.subject)
     |> assign(:flight_leg_header, email.headers["X-Flight-Leg"])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Mailers with Swoosh · 11 · Khartoum confluence mailer
      </p>

      <header class="masthead">
        <h1>Khartoum confluence mailer</h1>
        <p class="lede">
          Samira relays the Nile confluence leg with an X-Flight-Leg header and a verified board URL.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Board URL</dt>
        <dd id="board-url">{@board_url}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>X-Flight-Leg</dt>
        <dd id="flight-leg-header">{@flight_leg_header || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="relay-leg" type="button" phx-click="relay_leg">Relay confluence leg</button>
      </div>
    </Layouts.app>
    """
  end
end
