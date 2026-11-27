# Presence · 12 · Turku archipelago crew
#
# Teaches:
# - Presence leaves no ghost: a crashed or killed tab produces a leave diff because the tracker links the tracked process.
# - The board keeps its own short-lived ghost, "radio silence", with Process.send_after/3 and cancels it on a rejoin.
# - Map.drop/2 finds who went quiet between two lists; Map.pop/2 moves them out of radio silence on a rejoin or a fade.

defmodule PhoenixMultivitaminWeb.TurkuArchipelagoCrewLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:turku-seaplane-crew"
  @fade_after :timer.seconds(90)

  @impl true
  def mount(params, _session, socket) do
    crew_member = params["crew"] || "Aino"

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

      {:ok, _ref} =
        Presence.track(self(), @topic, crew_member, %{post: params["post"] || "Nauvo jetty"})
    end

    {:ok,
     socket
     |> assign_scenario("Turku archipelago crew", crew_member, "Cessna 208 Caravan on floats")
     |> assign(on_air: Presence.list(@topic), silent: %{})}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: %{joins: joins}}, socket) do
    on_air = Presence.list(@topic)
    gone_quiet = Map.drop(socket.assigns.on_air, Map.keys(on_air))

    silent =
      socket.assigns.silent
      |> cancel_silence(Map.keys(joins))
      |> start_silence(gone_quiet)

    {:noreply, assign(socket, on_air: on_air, silent: silent)}
  end

  def handle_info({:fade, crew_member}, socket) do
    {_silence, silent} = Map.pop(socket.assigns.silent, crew_member)
    {:noreply, assign(socket, :silent, silent)}
  end

  defp start_silence(silent, gone_quiet) do
    Enum.reduce(gone_quiet, silent, fn {crew_member, %{metas: [last | _]}}, acc ->
      timer = Process.send_after(self(), {:fade, crew_member}, @fade_after)
      Map.put(acc, crew_member, %{post: last.post, timer: timer})
    end)
  end

  defp cancel_silence(silent, returning) do
    Enum.reduce(returning, silent, fn crew_member, acc ->
      case Map.pop(acc, crew_member) do
        {%{timer: timer}, rest} ->
          Process.cancel_timer(timer)
          rest

        {nil, rest} ->
          rest
      end
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 12 · Turku archipelago crew
      </p>

      <h1>Turku archipelago crew</h1>
      <p class="lede">
        {@clerk} coordinates the {@craft} shuttling between Turku and the outer islands. When a
        crew tablet drops off, the crew member stays under radio silence for a while instead of
        vanishing.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="scenario mt-6 grid gap-6 sm:grid-cols-2">
        <section id="on-air">
          <h2>On air</h2>
          <p
            :for={{crew_member, %{metas: [meta | _]}} <- Enum.sort(@on_air)}
            id={"on-air-#{crew_member}"}
          >
            {crew_member} · {meta.post}
          </p>
        </section>
        <section id="radio-silence">
          <h2>Radio silence</h2>
          <p :for={{crew_member, silence} <- Enum.sort(@silent)} id={"silent-#{crew_member}"}>
            {crew_member} · last heard at {silence.post}
          </p>
        </section>
      </div>
    </Layouts.app>
    """
  end
end
