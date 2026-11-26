# PubSub · 13 · Beirut cedars warning
#
# Teaches:
# - Capstone: two desks, one broadcast_from!/4, no echo on the issuing desk
# - PubSub fans the warning out; each receiving desk replies point-to-point with send/2
# - handle_params/3 picks the desk; streams re-insert a warning when its acknowledgements change

defmodule PhoenixMultivitaminWeb.BeirutCedarsWarningLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.CedarsWarning

  @topic "beirut:cedars-warnings"
  @desks %{"tower" => "Beirut Tower", "apron" => "Apron Control", "approach" => "Beirut Approach"}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario("Beirut cedars warning", "Nour", "Airbus A321neo")
     |> assign(
       desks: @desks,
       hazards: CedarsWarning.hazards(),
       runways: CedarsWarning.runways(),
       issued: %{}
     )
     |> stream(:warnings, [])}
  end

  @impl true
  def handle_params(%{"desk" => desk}, _uri, socket) when is_map_key(@desks, desk) do
    {:noreply, assign(socket, :desk, @desks[desk])}
  end

  def handle_params(_params, _uri, socket), do: {:noreply, assign(socket, :desk, @desks["tower"])}

  @impl true
  def handle_event("issue_warning", warning_params, socket) do
    case CedarsWarning.issue(warning_params, socket.assigns.desk) do
      {:ok, warning} ->
        Phoenix.PubSub.broadcast_from!(PhoenixMultivitamin.PubSub, self(), @topic, {:cedars_warning, warning})

        {:noreply,
         socket
         |> update(:issued, &Map.put(&1, warning.id, warning))
         |> stream_insert(:warnings, warning, at: 0, limit: 20)}

      {:error, :unknown_hazard_or_runway} ->
        {:noreply, put_flash(socket, :error, "Choose a listed hazard and a Beirut runway")}
    end
  end

  @impl true
  def handle_info({:cedars_warning, %CedarsWarning{origin: origin} = warning}, socket) do
    send(origin, {:cedars_ack, warning.id, socket.assigns.desk})
    {:noreply, stream_insert(socket, :warnings, warning, at: 0, limit: 20)}
  end

  def handle_info({:cedars_ack, warning_id, desk}, socket) do
    case Map.fetch(socket.assigns.issued, warning_id) do
      {:ok, warning} ->
        acknowledged = CedarsWarning.acknowledge(warning, desk)

        {:noreply,
         socket
         |> update(:issued, &Map.put(&1, warning_id, acknowledged))
         |> stream_insert(:warnings, acknowledged)}

      :error ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 13 · Beirut cedars warning
      </p>
      <header class="masthead">
        <h1>Beirut cedars warning</h1>
        <p class="lede">
          {@clerk} issues runway hazard warnings at Rafic Hariri International. One broadcast
          reaches the other desks; their acknowledgements come straight back to the issuer.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <nav class="watch-switcher">
        <.link :for={{slug, label} <- Enum.sort(@desks)} id={"desk-#{slug}"}
          patch={~p"/features/15-pubsub/13-beirut-cedars-warning?#{[desk: slug]}"}
          class={["rounded px-3 py-1 transition hover:bg-green-50", label == @desk && "font-bold underline"]}>
          {label}
        </.link>
      </nav>
      <p id="current-desk" class="mount-banner">{@desk}</p>

      <form id="warning-form" phx-submit="issue_warning" class="scenario my-6 flex flex-wrap gap-3">
        <select id="warning-hazard" name="hazard" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={{key, label} <- Enum.sort(@hazards)} value={key}>{label}</option>
        </select>
        <select id="warning-runway" name="runway" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={runway <- @runways} value={runway}>Runway {runway}</option>
        </select>
        <button id="issue-warning" type="submit"
          class="rounded-lg bg-red-900 px-5 py-2 text-white transition hover:bg-red-800">
          Issue warning
        </button>
      </form>

      <ul id="cedars-warnings" phx-update="stream" class="watch-log">
        <li id="cedars-warnings-empty" class="hidden only:block">No warnings in force</li>
        <li :for={{dom_id, warning} <- @streams.warnings} id={dom_id}>
          <span class="warning-text">{to_string(warning)}</span>
          <span :if={warning.acks != []} class="warning-acks">
            · acknowledged by {Enum.join(warning.acks, ", ")}
          </span>
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
