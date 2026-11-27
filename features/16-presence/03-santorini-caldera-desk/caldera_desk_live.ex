# Presence · 03 · Santorini caldera desk
#
# Teaches:
# - A presence module with init/1 and handle_metas/4 acts as a presence client inside the tracker.
# - handle_metas/4 receives the full presences map, so it can tell a desk departure from a closed second console.
# - The LiveView subscribes to domain events, not presence_diff, and streams them with a bounded log.

defmodule PhoenixMultivitaminWeb.SantoriniCalderaDeskLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.SantoriniCalderaPresence, as: DeskPresence

  @topic "presence:santorini-caldera-desk"
  @counters %{"check-in" => "Check-in 4", "transfer" => "Transfer desk", "gate" => "Gate B2"}

  @impl true
  def mount(params, _session, socket) do
    agent = params["agent"] || "Nikos"
    counter = Map.get(@counters, params["counter"], "Check-in 4")

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic <> ":log")
      {:ok, _ref} = DeskPresence.track(self(), @topic, agent, %{counter: counter})
    end

    {:ok,
     socket
     |> assign_scenario("Santorini caldera desk", agent, "Sky Express ATR 72-600")
     |> assign(:counter, counter)
     |> stream_configure(:desk_log, dom_id: &"desk-event-#{elem(&1, 0)}")
     |> stream(:desk_log, [])}
  end

  @impl true
  def handle_info({:caldera_desk, event}, socket) do
    entry = {System.unique_integer([:positive, :monotonic]), describe(event)}
    {:noreply, stream_insert(socket, :desk_log, entry, at: 0, limit: 12)}
  end

  defp describe({:took_desk, agent, counter, handover}),
    do: "#{agent} took the caldera desk at #{counter} (handover #{handover} this shift)"

  defp describe({:second_console, agent, open}),
    do: "#{agent} opened another console (#{open} open)"

  defp describe({:closed_console, agent, remaining}),
    do: "#{agent} closed a console and is still at the desk (#{remaining} open)"

  defp describe({:left_desk, agent}), do: "#{agent} left the caldera desk"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 03 · Santorini caldera desk
      </p>

      <h1>Santorini caldera desk</h1>
      <p class="lede">
        {@clerk} staffs {@counter} at Santorini while the {@craft} turns around for Heraklion.
        The desk log shows who took the desk, who opened another console, and who really left.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ol id="desk-log" phx-update="stream" class="scenario watch-log mt-6">
        <li id="desk-log-empty" class="hidden only:block">
          The desk log fills in as agents connect.
        </li>
        <li :for={{dom_id, {_seq, line}} <- @streams.desk_log} id={dom_id}>{line}</li>
      </ol>
    </Layouts.app>
    """
  end
end
