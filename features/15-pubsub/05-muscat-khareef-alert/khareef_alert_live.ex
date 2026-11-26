# PubSub · 05 · Muscat khareef alert
#
# Teaches:
# - handle_info/2 clauses for broadcast tuples, guarded by alert level and gust speed
# - A broadcast and a Process.send_after/3 timer arrive through the same callback
# - A repeated variable in the head matches the clear timer to the current alert serial

defmodule PhoenixMultivitaminWeb.MuscatKhareefAlertLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @topic "muscat:khareef-alerts"
  @alert_hold_ms :timer.minutes(15)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario("Muscat khareef alert", "Salim", "Boeing 737 MAX 8")
     |> assign(alert: nil, serial: 0, advisories: [], ignored: 0)}
  end

  @impl true
  def handle_event("report_gust", %{"gust_kt" => gust}, socket) do
    gust_kt = String.to_integer(gust)

    level =
      cond do
        gust_kt >= 45 -> :red
        gust_kt >= 30 -> :amber
        true -> :advisory
      end

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:khareef, level, %{gust_kt: gust_kt}}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:khareef, level, %{gust_kt: gust_kt}}, socket)
      when level in [:amber, :red] and is_integer(gust_kt) do
    serial = socket.assigns.serial + 1
    Process.send_after(self(), {:clear_alert, serial}, @alert_hold_ms)
    {:noreply, assign(socket, alert: {level, gust_kt}, serial: serial)}
  end

  def handle_info({:khareef, :advisory, %{gust_kt: gust_kt}}, socket) do
    {:noreply, update(socket, :advisories, &Enum.take(["Gusting #{gust_kt} kt" | &1], 3))}
  end

  def handle_info({:clear_alert, serial}, %{assigns: %{serial: serial}} = socket) do
    {:noreply, assign(socket, :alert, nil)}
  end

  def handle_info(_stale_or_unknown, socket) do
    {:noreply, update(socket, :ignored, &(&1 + 1))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 05 · Muscat khareef alert
      </p>
      <header class="masthead">
        <h1>Muscat khareef alert</h1>
        <p class="lede">
          {@clerk} watches monsoon gusts on Muscat's runway 08L. Amber and red alerts hold for
          fifteen minutes unless a newer alert replaces them.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form id="gust-form" phx-submit="report_gust" class="scenario my-6 flex gap-3">
        <select id="gust-kt" name="gust_kt" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={gust <- [18, 26, 34, 48]} value={gust}>{gust} kt</option>
        </select>
        <button
          id="report-gust"
          type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800"
        >
          Report gust
        </button>
      </form>

      <%= case @alert do %>
        <% {level, gust_kt} -> %>
          <p id="khareef-alert" class={["mount-banner", level == :red && "font-bold text-red-800"]}>
            Alert {@serial}: {level |> Atom.to_string() |> String.upcase()} · gusting {gust_kt} kt
          </p>
        <% nil -> %>
          <p id="khareef-clear" class="mount-banner">No khareef alert in force</p>
      <% end %>

      <ul id="advisories" class="watch-log">
        <li :for={advisory <- @advisories}>{advisory}</li>
      </ul>
      <p id="ignored-count">{@ignored} stale or unknown messages ignored</p>
    </Layouts.app>
    """
  end
end
