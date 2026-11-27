# Mailers with Swoosh · 10 · Luxor Nile mailer
#
# Teaches:
# - Surfacing deliver error tuples on the board without raising
# - Separating :from_not_set from domain {:runway_closed, to}

defmodule PhoenixMultivitaminWeb.LuxorNileMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.LuxorNileMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Luxor Nile mailer", "Nour", "Airbus A220")
     |> assign(:station, "Luxor International · Nile tower")
     |> assign(:result, :idle)
     |> assign(:error_reason, nil)
     |> assign(:last_subject, nil)}
  end

  @impl true
  def handle_event("send_without_from", _params, socket) do
    socket =
      case LuxorNileMailer.deliver_without_from(socket.assigns.clerk) do
        {:ok, email, _meta} ->
          assign(socket, result: :sent, last_subject: email.subject, error_reason: nil)

        {:error, reason, email} ->
          assign(socket,
            result: :failed,
            last_subject: email.subject,
            error_reason: format_reason(reason)
          )
      end

    {:noreply, socket}
  end

  def handle_event("send_runway", %{"status" => status}, socket) do
    status_atom = String.to_existing_atom(status)

    socket =
      case LuxorNileMailer.deliver_runway_status(socket.assigns.clerk, status_atom) do
        {:ok, email, _meta} ->
          assign(socket, result: :sent, last_subject: email.subject, error_reason: nil)

        {:error, reason, email} ->
          assign(socket,
            result: :failed,
            last_subject: email.subject,
            error_reason: format_reason(reason)
          )
      end

    {:noreply, socket}
  end

  defp format_reason(:from_not_set), do: "from_not_set"

  defp format_reason({:runway_closed, to}) do
    "runway_closed:#{inspect(to)}"
  end

  defp format_reason(other), do: inspect(other)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 10 · Luxor Nile mailer
      </p>

      <header class="masthead">
        <h1>Luxor Nile mailer</h1>
        <p class="lede">
          Nour's Nile tower shows deliver error tuples: a missing from, and a runway-closed adapter refusal.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Result</dt>
        <dd id="result">{@result}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>Error</dt>
        <dd id="error-reason">{@error_reason || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button id="send-without-from" type="button" phx-click="send_without_from">
          Send without from
        </button>
        <button
          id="send-runway-open"
          type="button"
          phx-click="send_runway"
          phx-value-status="open"
        >
          Send runway open
        </button>
        <button
          id="send-runway-closed"
          type="button"
          phx-click="send_runway"
          phx-value-status="closed"
        >
          Send runway closed
        </button>
      </div>
    </Layouts.app>
    """
  end
end
