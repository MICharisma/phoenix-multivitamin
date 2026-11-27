# Mailers with Swoosh · 04 · Salvador Pelourinho mailer
#
# Teaches:
# - Showing the Local mailbox preview path beside the configured Test adapter
# - Surfacing the Message-ID Local storage stamps onto the email

defmodule PhoenixMultivitaminWeb.SalvadorPelourinhoMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.SalvadorPelourinhoMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Salvador Pelourinho mailer", "Caetano", "Embraer 190")
     |> assign(:station, "Deputado Luís Eduardo Magalhães · Pelourinho tower")
     |> assign(:configured_adapter, inspect(SalvadorPelourinhoMailer.configured_adapter()))
     |> assign(:preview_path, SalvadorPelourinhoMailer.mailbox_preview_path())
     |> assign(:local_subject, nil)
     |> assign(:message_id, nil)
     |> assign(:stored_header, nil)}
  end

  @impl true
  def handle_event("post_plaza_brief", _params, socket) do
    SalvadorPelourinhoMailer.flush_local_mailbox()

    {:ok, _email, stored, message_id} =
      SalvadorPelourinhoMailer.deliver_to_local_mailbox("Caetano", "Terreiro de Jesus")

    {:noreply,
     socket
     |> assign(:local_subject, stored.subject)
     |> assign(:message_id, message_id)
     |> assign(:stored_header, stored.headers["X-Pelourinho-Plaza"])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Mailers with Swoosh · 04 · Salvador Pelourinho mailer
      </p>

      <header class="masthead">
        <h1>Salvador Pelourinho mailer</h1>
        <p class="lede">
          Caetano posts the plaza brief into the Local adapter so /dev/mailbox can preview it,
          even while mix test keeps the Test adapter as the default.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Configured adapter</dt>
        <dd id="configured-adapter">{@configured_adapter}</dd>
        <dt>Mailbox preview</dt>
        <dd id="preview-path">{@preview_path}</dd>
        <dt>Local subject</dt>
        <dd id="local-subject">{@local_subject || "none"}</dd>
        <dt>Message-ID</dt>
        <dd id="message-id">{@message_id || "none"}</dd>
        <dt>Stored plaza header</dt>
        <dd id="stored-header">{@stored_header || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="post-plaza-brief" type="button" phx-click="post_plaza_brief">
          Post plaza brief to Local mailbox
        </button>
      </div>
    </Layouts.app>
    """
  end
end
