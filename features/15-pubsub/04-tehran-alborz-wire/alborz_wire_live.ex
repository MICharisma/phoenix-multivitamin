# PubSub · 04 · Tehran Alborz wire
#
# Teaches:
# - Topics named for the station ("alborz:IKA"), built and decoded with binary patterns
# - A for comprehension subscribes one desk to every station it watches
# - handle_info/2 destructures the socket so a guard can test the station against the board

defmodule PhoenixMultivitaminWeb.TehranAlborzWireLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @watched_stations ~w(IKA THR)
  @wire_stations ~w(IKA THR MHD)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      for station <- @watched_stations do
        :ok = Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, wire_topic(station))
      end
    end

    {:ok,
     socket
     |> assign_scenario("Tehran Alborz wire", "Shirin", "Airbus A300B4")
     |> assign(
       board: Map.new(@watched_stations, &{&1, []}),
       wire_stations: @wire_stations,
       last_topic: nil
     )}
  end

  @impl true
  def handle_event("send_wire", %{"station" => station, "notice" => notice}, socket)
      when station in @wire_stations and byte_size(notice) > 0 do
    topic = wire_topic(station)
    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, topic, {:alborz_wire, topic, notice})
    {:noreply, assign(socket, :last_topic, topic)}
  end

  def handle_event("send_wire", _params, socket) do
    {:noreply, put_flash(socket, :error, "A wire needs a known station and a notice")}
  end

  @impl true
  def handle_info(
        {:alborz_wire, "alborz:" <> station, notice},
        %{assigns: %{board: board}} = socket
      )
      when is_map_key(board, station) do
    {:noreply, assign(socket, :board, Map.update!(board, station, &[notice | &1]))}
  end

  defp wire_topic(station), do: "alborz:" <> station

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 04 · Tehran Alborz wire
      </p>
      <header class="masthead">
        <h1>Tehran Alborz wire</h1>
        <p class="lede">
          {@clerk} watches the Imam Khomeini and Mehrabad wires under the Alborz. Each station
          has its own topic; Mashhad traffic goes out on a topic this desk never joined.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form id="wire-form" phx-submit="send_wire" class="scenario my-6 space-y-3">
        <select id="wire-station" name="station" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={station <- @wire_stations} value={station}>{station}</option>
        </select>
        <input
          id="wire-notice"
          name="notice"
          type="text"
          placeholder="Snow on the Alborz passes"
          class="block w-full rounded-lg border border-stone-400 px-3 py-2"
        />
        <button
          id="send-wire"
          type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800"
        >
          Send on the station wire
        </button>
      </form>
      <p :if={@last_topic} id="last-topic">Last wire went out on <code>{@last_topic}</code></p>

      <section
        :for={{station, notices} <- Enum.sort(@board)}
        id={"wire-#{station}"}
        class="scenario mt-4"
      >
        <h2>{station}</h2>
        <p :if={notices == []} class="planned">No wire yet</p>
        <ul class="watch-log">
          <li :for={notice <- notices}>{notice}</li>
        </ul>
      </section>
    </Layouts.app>
    """
  end
end
