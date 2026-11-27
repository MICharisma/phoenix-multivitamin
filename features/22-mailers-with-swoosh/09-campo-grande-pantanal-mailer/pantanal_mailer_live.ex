# Mailers with Swoosh · 09 · Campo Grande Pantanal mailer
#
# Teaches:
# - Choosing sync versus Task.async delivery from the board
# - Recording which path ran without changing the email content

defmodule PhoenixMultivitaminWeb.CampoGrandePantanalMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.CampoGrandePantanalMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Campo Grande Pantanal mailer", "Davi", "Cessna Caravan")
     |> assign(:station, "Campo Grande · Pantanal desk")
     |> assign(:delivery_mode, :idle)
     |> assign(:last_subject, nil)}
  end

  @impl true
  def handle_event("deliver_sync", _params, socket) do
    {:ok, :sync, email, _meta} =
      CampoGrandePantanalMailer.deliver_now(
        socket.assigns.clerk,
        socket.assigns.craft,
        "Baía Grande"
      )

    {:noreply,
     socket
     |> assign(:delivery_mode, :sync)
     |> assign(:last_subject, email.subject)}
  end

  def handle_event("deliver_async", _params, socket) do
    {:ok, :async, email, _meta} =
      CampoGrandePantanalMailer.deliver_async(
        socket.assigns.clerk,
        socket.assigns.craft,
        "Baía Grande"
      )

    {:noreply,
     socket
     |> assign(:delivery_mode, :async)
     |> assign(:last_subject, email.subject)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Mailers with Swoosh · 09 · Campo Grande Pantanal mailer
      </p>

      <header class="masthead">
        <h1>Campo Grande Pantanal mailer</h1>
        <p class="lede">
          Davi sends the Baía Grande wetland brief now, or through an Oban-free Task.async hop.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Mode</dt>
        <dd id="delivery-mode">{@delivery_mode}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="deliver-sync" type="button" phx-click="deliver_sync">Deliver now</button>
        <button id="deliver-async" type="button" phx-click="deliver_async">Deliver via Task</button>
      </div>
    </Layouts.app>
    """
  end
end
