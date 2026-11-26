# Mailers with Swoosh · 13 · Lalibela rock mailer
#
# Teaches:
# - Capstone board: Test deliver plus Local mailbox preview of the same email
# - Showing inline versus regular attachment counts and the env adapter

defmodule PhoenixMultivitaminWeb.LalibelaRockMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.LalibelaRockMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Lalibela rock mailer", "Kidist", "DHC-6 Twin Otter")
     |> assign(:station, "Lalibela · rock-hewn desk")
     |> assign(:env_adapter, inspect(LalibelaRockMailer.mailer_adapter()))
     |> assign(:preview_path, "/dev/mailbox")
     |> assign(:last_subject, nil)
     |> assign(:inline_count, 0)
     |> assign(:regular_count, 0)
     |> assign(:local_message_id, nil)
     |> assign(:html_has_cid?, false)}
  end

  @impl true
  def handle_event("send_test_brief", _params, socket) do
    {:ok, email, _meta} =
      LalibelaRockMailer.deliver_via_test(
        socket.assigns.clerk,
        socket.assigns.craft,
        "Bete Giyorgis"
      )

    {:noreply, assign_email_stats(socket, email)}
  end

  def handle_event("preview_local_brief", _params, socket) do
    {:ok, email, _stored, message_id} =
      LalibelaRockMailer.deliver_via_local_preview(
        socket.assigns.clerk,
        socket.assigns.craft,
        "Bete Giyorgis"
      )

    {:noreply,
     socket
     |> assign_email_stats(email)
     |> assign(:local_message_id, message_id)}
  end

  defp assign_email_stats(socket, email) do
    {inline, regular} =
      Enum.split_with(email.attachments, fn
        %{type: :inline} -> true
        _ -> false
      end)

    socket
    |> assign(:last_subject, email.subject)
    |> assign(:inline_count, length(inline))
    |> assign(:regular_count, length(regular))
    |> assign(
      :html_has_cid?,
      String.contains?(email.html_body, "cid:#{LalibelaRockMailer.crest_cid()}")
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 13 · Lalibela rock mailer
      </p>

      <header class="masthead">
        <h1>Lalibela rock mailer</h1>
        <p class="lede">
          Kidist's rock-hewn desk sends a pilgrimage brief with HTML, text, an inline crest,
          and a CSV itinerary — then previews the same mail in the Local mailbox.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Env adapter</dt>
        <dd id="env-adapter">{@env_adapter}</dd>
        <dt>Mailbox preview</dt>
        <dd id="preview-path">{@preview_path}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>Inline attachments</dt>
        <dd id="inline-count">{@inline_count}</dd>
        <dt>Regular attachments</dt>
        <dd id="regular-count">{@regular_count}</dd>
        <dt>HTML has cid</dt>
        <dd id="html-has-cid">{@html_has_cid?}</dd>
        <dt>Local Message-ID</dt>
        <dd id="local-message-id">{@local_message_id || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="send-test-brief" type="button" phx-click="send_test_brief">
          Send via Test adapter
        </button>
        <button id="preview-local-brief" type="button" phx-click="preview_local_brief">
          Preview in Local mailbox
        </button>
      </div>
    </Layouts.app>
    """
  end
end
