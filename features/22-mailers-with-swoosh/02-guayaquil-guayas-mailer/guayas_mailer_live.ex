# Mailers with Swoosh · 02 · Guayaquil Guayas mailer
#
# Teaches:
# - Pattern-matching the with result in handle_event
# - Showing cc, bcc, and reply_to on the board after a successful compose

defmodule PhoenixMultivitaminWeb.GuayaquilGuayasMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.GuayaquilGuayasMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Guayaquil Guayas mailer", "Marisol", "DHC-6 Twin Otter")
     |> assign(:station, "José Joaquín de Olmedo · Guayas tides")
     |> assign(:officer, "Marisol")
     |> assign(:compose_status, :idle)
     |> assign(:last_subject, nil)
     |> assign(:last_cc, nil)
     |> assign(:last_bcc_count, 0)
     |> assign(:last_reply_to, nil)
     |> assign(:html_preview, nil)}
  end

  @impl true
  def handle_event("compose_tide", %{"officer" => officer}, socket) do
    case GuayaquilGuayasMailer.compose_tide_notice(officer, tide: "ebb") do
      {:ok, email} ->
        {:noreply,
         socket
         |> assign(:officer, officer)
         |> assign(:compose_status, :ready)
         |> assign(:last_subject, email.subject)
         |> assign(:last_cc, format_recipients(email.cc))
         |> assign(:last_bcc_count, length(email.bcc))
         |> assign(:last_reply_to, format_recipients(List.wrap(email.reply_to)))
         |> assign(:html_preview, email.html_body)}

      {:error, :unknown_officer} ->
        {:noreply,
         socket
         |> assign(:compose_status, :rejected)
         |> put_flash(:error, "No Guayas officer named #{officer}")}
    end
  end

  defp format_recipients(list) do
    Enum.map_join(list, ", ", fn
      {name, address} -> "#{name} <#{address}>"
      address when is_binary(address) -> address
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 02 · Guayaquil Guayas mailer
      </p>

      <header class="masthead">
        <h1>Guayaquil Guayas mailer</h1>
        <p class="lede">
          Marisol's tide desk mails the mangrove hop with HTML, text, cc, bcc, and a hydrologist reply-to.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Status</dt>
        <dd id="compose-status">{@compose_status}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>CC</dt>
        <dd id="last-cc">{@last_cc || "none"}</dd>
        <dt>BCC count</dt>
        <dd id="last-bcc-count">{@last_bcc_count}</dd>
        <dt>Reply-to</dt>
        <dd id="last-reply-to">{@last_reply_to || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button
          id="compose-marisol"
          type="button"
          phx-click="compose_tide"
          phx-value-officer="Marisol"
        >
          Compose for Marisol
        </button>
        <button
          id="compose-stranger"
          type="button"
          phx-click="compose_tide"
          phx-value-officer="Nerea"
        >
          Compose for Nerea
        </button>
      </div>

      <div id="html-preview" class="scenario">{raw(@html_preview || "No HTML yet")}</div>
    </Layouts.app>
    """
  end
end
