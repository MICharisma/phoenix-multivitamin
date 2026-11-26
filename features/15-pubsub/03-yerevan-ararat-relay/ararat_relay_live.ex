# PubSub · 03 · Yerevan Ararat relay
#
# Teaches:
# - Phoenix.PubSub.broadcast_from/4 with self() so the relaying desk skips its own echo
# - The sender logs locally and receivers log from handle_info/2 through one shared function
# - mount/3 clauses match an optional desk query parameter

defmodule PhoenixMultivitaminWeb.YerevanAraratRelayLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @topic "yerevan:ararat-visibility"
  @desks %{"zvartnots" => "Zvartnots tower", "gyumri" => "Gyumri Shirak tower"}

  @impl true
  def mount(%{"desk" => desk}, _session, socket) when is_map_key(@desks, desk) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario("Yerevan Ararat relay", "Armen", "Airbus A320neo")
     |> assign(desk: Map.fetch!(@desks, desk), reports: [])}
  end

  def mount(_params, session, socket), do: mount(%{"desk" => "zvartnots"}, session, socket)

  @impl true
  def handle_event("relay_visibility", %{"metres" => metres}, socket) do
    case Integer.parse(metres) do
      {visibility_m, ""} when visibility_m in 50..10_000 ->
        report = %{desk: socket.assigns.desk, visibility_m: visibility_m}

        Phoenix.PubSub.broadcast_from(
          PhoenixMultivitamin.PubSub,
          self(),
          @topic,
          {:ararat_visibility, report}
        )

        {:noreply, log_report(socket, report)}

      _unreadable ->
        {:noreply, put_flash(socket, :error, "Visibility must be 50 to 10,000 metres")}
    end
  end

  @impl true
  def handle_info({:ararat_visibility, %{visibility_m: metres} = report}, socket)
      when is_integer(metres) do
    {:noreply, log_report(socket, report)}
  end

  defp log_report(socket, %{desk: desk, visibility_m: metres}) do
    line = if desk == socket.assigns.desk, do: "You relayed #{metres} m", else: "#{desk}: #{metres} m"
    update(socket, :reports, &[line | &1])
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 03 · Yerevan Ararat relay
      </p>
      <header class="masthead">
        <h1>Yerevan Ararat relay</h1>
        <p class="lede">
          {@clerk} relays the visibility toward Ararat between Armenian tower desks. The relaying
          desk logs its own report once, without waiting for an echo.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="desk-name" class="mount-banner">{@desk}</p>
      <form id="visibility-form" phx-submit="relay_visibility" class="scenario my-6 flex gap-3">
        <label for="visibility-metres" class="font-semibold">Visibility (m)</label>
        <input id="visibility-metres" name="metres" type="number" value="4000"
          class="rounded-lg border border-stone-400 px-3 py-2" />
        <button id="relay-visibility" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Relay
        </button>
      </form>

      <p id="report-count">{length(@reports)} reports logged</p>
      <ol id="visibility-log" class="watch-log">
        <li :for={line <- @reports}>{line}</li>
      </ol>
    </Layouts.app>
    """
  end
end
