# Mailers with Swoosh · 01 · Medellín Guatapé mailer
#
# Teaches:
# - mount/3 seeds an enforced watch brief
# - Building the email on click and inspecting fields before any adapter runs

defmodule PhoenixMultivitaminWeb.MedellinGuatapeMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MedellinGuatapeMailer
  alias PhoenixMultivitaminWeb.MedellinGuatapeWatchBrief

  @impl true
  def mount(_params, _session, socket) do
    brief = %MedellinGuatapeWatchBrief{
      controller: "Valentina",
      craft: "ATR 72-600",
      runway: "01",
      qnh: 1022
    }

    {:ok,
     socket
     |> assign_scenario("Medellín Guatapé mailer", "Valentina", "ATR 72-600")
     |> assign(:station, "José María Córdova · Guatapé desk")
     |> assign(:brief, brief)
     |> assign(:draft_subject, nil)
     |> assign(:draft_text, nil)
     |> assign(:draft_to, nil)}
  end

  @impl true
  def handle_event("compose_brief", _params, socket) do
    email =
      MedellinGuatapeMailer.build_brief_email(
        socket.assigns.brief,
        {"Valentina", "valentina@skrg.gov.co"}
      )

    {:noreply,
     socket
     |> assign(:draft_subject, email.subject)
     |> assign(:draft_text, email.text_body)
     |> assign(:draft_to, format_mailbox(email.to))}
  end

  defp format_mailbox([{name, address}]), do: "#{name} <#{address}>"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 01 · Medellín Guatapé mailer
      </p>

      <header class="masthead">
        <h1>Medellín Guatapé mailer</h1>
        <p class="lede">
          Valentina drafts the Guatapé ridge brief for the ATR before anyone presses deliver.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Runway</dt>
        <dd id="runway">{@brief.runway}</dd>
        <dt>QNH</dt>
        <dd id="qnh">{@brief.qnh}</dd>
        <dt>Draft subject</dt>
        <dd id="draft-subject">{@draft_subject || "none"}</dd>
        <dt>Draft to</dt>
        <dd id="draft-to">{@draft_to || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="compose-brief" type="button" phx-click="compose_brief">
          Compose watch brief
        </button>
      </div>

      <pre id="draft-text" class="scenario">{@draft_text || "No draft yet"}</pre>
    </Layouts.app>
    """
  end
end
