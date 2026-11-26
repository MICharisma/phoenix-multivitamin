# PubSub · 01 · Baku Caspian handover
#
# Teaches:
# - Phoenix.PubSub.subscribe/2 only after connected?/1, never in the static render
# - The posting desk hears its own handover from the broadcast, like every other desk
# - A guarded event head rejects a sector the board does not own

defmodule PhoenixMultivitaminWeb.BakuCaspianHandoverLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @topic "baku:caspian-handovers"
  @sectors ~w(Caspian-North Caspian-South Absheron)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario("Baku Caspian handover", "Leyla", "Airbus A320")
     |> assign(
       listening?: connected?(socket),
       handovers: [],
       sectors: @sectors,
       handover_form: to_form(%{"sector" => "Caspian-North", "controller" => ""}, as: :handover)
     )}
  end

  @impl true
  def handle_event("post_handover", %{"handover" => %{"sector" => sector} = handover}, socket)
      when sector in @sectors do
    controller = handover |> Map.get("controller", "") |> String.trim()

    Phoenix.PubSub.broadcast(
      PhoenixMultivitamin.PubSub,
      @topic,
      {:handover_posted, sector, controller}
    )

    {:noreply, socket}
  end

  def handle_event("post_handover", _params, socket) do
    {:noreply, put_flash(socket, :error, "Pick one of the Caspian sectors on this board")}
  end

  @impl true
  def handle_info({:handover_posted, sector, controller}, socket) do
    {:noreply, update(socket, :handovers, &Enum.take([{sector, controller} | &1], 5))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 01 · Baku Caspian handover
      </p>
      <header class="masthead">
        <h1>Baku Caspian handover</h1>
        <p class="lede">
          {@clerk} posts sector handovers at Heydar Aliyev approach; every open desk,
          including hers, hears them from the same broadcast.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="listening-state" class="mount-banner">
        {if @listening?, do: "Subscribed to the Caspian handover topic",
          else: "Static render: not subscribed yet"}
      </p>

      <.form for={@handover_form} id="handover-form" phx-submit="post_handover"
        class="scenario my-6 space-y-4">
        <.input field={@handover_form[:sector]} type="select" label="Sector" options={@sectors} />
        <.input field={@handover_form[:controller]} type="text" label="Incoming controller" />
        <button id="post-handover" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Post handover
        </button>
      </.form>

      <ol id="handover-log" class="watch-log">
        <li :for={{{sector, controller}, index} <- Enum.with_index(@handovers)} id={"handover-#{index}"}>
          {sector} handed to {controller}
        </li>
      </ol>
    </Layouts.app>
    """
  end
end
