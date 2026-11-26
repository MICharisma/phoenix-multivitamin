# PubSub · 08 · Abu Dhabi Yas stand call
#
# Teaches:
# - Two LiveView modules on one topic: the ramp dispatcher and each nested stand marshal
# - live_render/3 children are separate processes; PubSub reaches them, parent assigns do not
# - Both directions share the topic, so each side ignores the other's message shape

defmodule PhoenixMultivitaminWeb.AbuDhabiYasStandCallLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.YasStandMarshalLive

  @topic "abu-dhabi:yas-stand-calls"
  @stands ~w(31 32)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario("Abu Dhabi Yas stand call", "Khalid", "Airbus A350-1000")
     |> assign(stands: @stands, topic: @topic, ready: %{})}
  end

  @impl true
  def handle_event("call_stand", %{"stand" => stand, "flight" => flight}, socket)
      when stand in @stands and flight != "" do
    Phoenix.PubSub.broadcast!(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:stand_call, stand, String.upcase(flight)}
    )

    {:noreply, update(socket, :ready, &Map.delete(&1, stand))}
  end

  def handle_event("call_stand", _params, socket) do
    {:noreply, put_flash(socket, :error, "Call a Yas stand with a flight number")}
  end

  @impl true
  def handle_info({:marshal_ready, stand, marshal}, socket) do
    {:noreply, update(socket, :ready, &Map.put(&1, stand, marshal))}
  end

  def handle_info({:stand_call, _stand, _flight}, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 08 · Abu Dhabi Yas stand call
      </p>
      <header class="masthead">
        <h1>Abu Dhabi Yas stand call</h1>
        <p class="lede">
          {@clerk} calls marshals to stands on the Zayed International apron. Each marshal
          panel is its own LiveView process listening on the same topic.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form id="stand-call-form" phx-submit="call_stand" class="scenario my-6 flex flex-wrap gap-3">
        <select id="call-stand" name="stand" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={stand <- @stands} value={stand}>Stand {stand}</option>
        </select>
        <input id="call-flight" name="flight" type="text" placeholder="EY17"
          class="rounded-lg border border-stone-400 px-3 py-2" />
        <button id="call-marshal" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Call marshal
        </button>
      </form>

      <ul id="ready-board" class="watch-log">
        <li :for={{stand, marshal} <- Enum.sort(@ready)} id={"ready-#{stand}"}>
          Stand {stand} ready · {marshal}
        </li>
      </ul>

      <div class="grid gap-4 sm:grid-cols-2">
        {for stand <- @stands do
          live_render(@socket, YasStandMarshalLive,
            id: "marshal-#{stand}",
            session: %{"stand" => stand, "topic" => @topic}
          )
        end}
      </div>
    </Layouts.app>
    """
  end
end
