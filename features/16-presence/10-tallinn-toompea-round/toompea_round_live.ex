# Presence · 10 · Tallinn Toompea round
#
# Teaches:
# - Presences rendered through a LiveView stream: the diff names the changed keys, and get_by_key/2 decides insert or delete.
# - stream_delete_by_dom_id/3 removes an inspector by a computed DOM id; stream_configure/3 makes inserts use the same id.
# - Streams cannot be counted, so a MapSet assign of keys on the round carries the headcount.

defmodule PhoenixMultivitaminWeb.TallinnToompeaRoundLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:tallinn-runway-round"

  @impl true
  def mount(params, _session, socket) do
    inspector = params["inspector"] || "Kadri"
    vehicle = params["vehicle"] || "Follow-me 2"

    inspectors =
      if connected?(socket) do
        Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

        {:ok, _ref} =
          Presence.track(self(), @topic, inspector, %{
            vehicle: vehicle,
            segment: "RWY 08 threshold"
          })

        Enum.map(Presence.list(@topic), &to_row/1)
      else
        []
      end

    {:ok,
     socket
     |> assign_scenario("Tallinn Toompea round", inspector, "Finnair ATR 72-500")
     |> assign(:on_round, MapSet.new(inspectors, & &1.id))
     |> stream_configure(:inspectors, dom_id: &dom_id(&1.id))
     |> stream(:inspectors, inspectors)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: diff}, socket) do
    changed = Map.keys(diff.joins) ++ Map.keys(diff.leaves)
    {:noreply, changed |> Enum.uniq() |> Enum.reduce(socket, &refresh_inspector/2)}
  end

  defp refresh_inspector(inspector, socket) do
    case Presence.get_by_key(@topic, inspector) do
      [] ->
        socket
        |> stream_delete_by_dom_id(:inspectors, dom_id(inspector))
        |> update(:on_round, &MapSet.delete(&1, inspector))

      %{metas: _metas} = presence ->
        socket
        |> stream_insert(:inspectors, to_row({inspector, presence}))
        |> update(:on_round, &MapSet.put(&1, inspector))
    end
  end

  defp to_row({inspector, %{metas: [primary | _] = metas}}) do
    %{id: inspector, vehicle: primary.vehicle, segment: primary.segment, screens: length(metas)}
  end

  defp headcount(on_round) do
    case MapSet.size(on_round) do
      1 -> "1 inspector on the round"
      count -> "#{count} inspectors on the round"
    end
  end

  defp dom_id(inspector), do: "inspector-" <> String.downcase(inspector)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 10 · Tallinn Toompea round
      </p>

      <h1>Tallinn Toompea round</h1>
      <p class="lede">
        {@clerk} drives the dawn runway inspection at Tallinn before the first {@craft} from
        Helsinki. Every inspector out on the round appears once, with their vehicle and segment.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="round-count">{headcount(@on_round)}</p>
      <ul id="round-inspectors" phx-update="stream" class="scenario watch-log mt-6">
        <li id="round-empty" class="hidden only:block">Nobody is out on the runway.</li>
        <li :for={{dom_id, row} <- @streams.inspectors} id={dom_id}>
          <strong>{row.id}</strong> · {row.vehicle} · {row.segment}
          <span :if={row.screens > 1} class="screen-count">· {row.screens} screens</span>
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
