# PubSub · 12 · Amman Nabatean hail
#
# Teaches:
# - One station topic instead of a topic per watch: subscribe/3 with a :sender filters per watch
# - A Phoenix.PubSub.Sender runs in the broadcaster and decides what each subscriber gets
# - handle_params/3 swaps the watch with unsubscribe_sender/3 and a fresh subscribe/3

defmodule PhoenixMultivitaminWeb.AmmanNabateanHailLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.PubSub
  alias PhoenixMultivitaminWeb.NabateanWatchSender

  @pubsub PhoenixMultivitamin.PubSub
  @station_topic "amman:nabatean-station"
  @watches %{"petra" => "Petra watch", "wadi-rum" => "Wadi Rum watch", "dead-sea" => "Dead Sea watch"}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Amman Nabatean hail", "Rania", "Airbus A320")
     |> assign(watches: @watches, watch: nil, hails: [])}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    watch = if Map.has_key?(@watches, params["watch"]), do: params["watch"], else: "petra"
    {:noreply, socket |> follow_watch(watch) |> assign(watch: watch)}
  end

  @impl true
  def handle_event("hail", %{"target" => "station", "text" => text}, socket) do
    {:noreply, send_hail(socket, :station, text)}
  end

  def handle_event("hail", %{"target" => watch, "text" => text}, socket)
      when is_map_key(@watches, watch) do
    {:noreply, send_hail(socket, watch, text)}
  end

  def handle_event("hail", _params, socket) do
    {:noreply, put_flash(socket, :error, "Hail the station or one of its watches")}
  end

  @impl true
  def handle_info({:nabatean_hail, scope, text}, socket) when scope in [:station, :watch] do
    {:noreply, update(socket, :hails, &[{scope, text} | &1])}
  end

  defp follow_watch(%{assigns: %{watch: watch}} = socket, watch), do: socket

  defp follow_watch(socket, next_watch) do
    if connected?(socket) do
      if old_watch = socket.assigns.watch do
        PubSub.unsubscribe_sender(@pubsub, @station_topic, {NabateanWatchSender, old_watch})
      end

      PubSub.subscribe(@pubsub, @station_topic, sender: {NabateanWatchSender, next_watch})
    end

    assign(socket, :hails, [])
  end

  defp send_hail(socket, target, text) do
    PubSub.broadcast(@pubsub, @station_topic, {:nabatean_hail, target, String.trim(text)})
    socket
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 12 · Amman Nabatean hail
      </p>
      <header class="masthead">
        <h1>Amman Nabatean hail</h1>
        <p class="lede">
          {@clerk} hails the southern watches from Amman Marka. Every watch shares one station
          topic; a sender module decides which hails reach which watch.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <nav class="watch-switcher">
        <.link :for={{slug, label} <- Enum.sort(@watches)} id={"switch-#{slug}"}
          patch={~p"/features/15-pubsub/12-amman-nabatean-hail?#{[watch: slug]}"}
          class={["rounded px-3 py-1 transition hover:bg-green-50", slug == @watch && "font-bold underline"]}>
          {label}
        </.link>
      </nav>
      <p id="current-watch" class="mount-banner">{@watches[@watch]}</p>

      <form id="hail-form" phx-submit="hail" class="scenario my-6 flex flex-wrap gap-3">
        <select id="hail-target" name="target" class="rounded-lg border border-stone-400 px-3 py-2">
          <option value="station">Whole station</option>
          <option :for={{slug, label} <- Enum.sort(@watches)} value={slug}>{label}</option>
        </select>
        <input id="hail-text" name="text" type="text" placeholder="Dust over the King's Highway"
          class="rounded-lg border border-stone-400 px-3 py-2" />
        <button id="send-hail" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Send hail
        </button>
      </form>

      <ol id="hail-log" class="watch-log">
        <li :for={{scope, text} <- @hails} class={"hail-#{scope}"}>{text}</li>
      </ol>
    </Layouts.app>
    """
  end
end
