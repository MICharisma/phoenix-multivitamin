# Mailers with Swoosh · 07 · Porto Alegre gaúcho mailer
#
# Teaches:
# - Sending a layout-wrapped HTML hold notice from the board
# - Exposing whether the HTML includes the layout header and footer markers

defmodule PhoenixMultivitaminWeb.PortoAlegreGauchoMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.PortoAlegreGauchoMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Porto Alegre gaúcho mailer", "Lorena", "Boeing 737-800")
     |> assign(:station, "Salgado Filho · gaúcho desk")
     |> assign(:layout_present?, false)
     |> assign(:last_subject, nil)}
  end

  @impl true
  def handle_event("send_pampeiro_hold", _params, socket) do
    {:ok, email} =
      PortoAlegreGauchoMailer.deliver_pampeiro_hold(
        socket.assigns.clerk,
        socket.assigns.craft,
        38,
        25
      )

    {:noreply,
     socket
     |> assign(:last_subject, email.subject)
     |> assign(
       :layout_present?,
       String.contains?(email.html_body, "gaucho-mail-header") and
         String.contains?(email.html_body, "gaucho-mail-footer")
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Mailers with Swoosh · 07 · Porto Alegre gaúcho mailer
      </p>

      <header class="masthead">
        <h1>Porto Alegre gaúcho mailer</h1>
        <p class="lede">
          Lorena wraps the pampeiro hold in a shared HTML mail layout before it leaves Salgado Filho.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>Layout present</dt>
        <dd id="layout-present">{@layout_present?}</dd>
      </dl>

      <div class="watch-actions">
        <button id="send-pampeiro-hold" type="button" phx-click="send_pampeiro_hold">
          Send pampeiro hold
        </button>
      </div>
    </Layouts.app>
    """
  end
end
