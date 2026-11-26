# PubSub · 11 · Madinah Hijaz hold wire
#
# Teaches:
# - broadcast/3 reaches the cluster, local_broadcast/3 this node, direct_broadcast/4 one named node
# - node_name/1 names this node; on a single node every reach lands on the same desks
# - A map of function captures picks the reach; with/else turns an unknown reach into a flash

defmodule PhoenixMultivitaminWeb.MadinahHijazHoldWireLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.PubSub

  @pubsub PhoenixMultivitamin.PubSub
  @topic "madinah:hijaz-holds"
  @fixes ~w(TAYBA KHAYB BADRA)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(@pubsub, @topic)

    {:ok,
     socket
     |> assign_scenario("Madinah Hijaz hold wire", "Abdullah", "Airbus A321neo")
     |> assign(
       node_name: PubSub.node_name(@pubsub),
       connected_nodes: Node.list(),
       fixes: @fixes,
       holds: [],
       last_reach: nil
     )}
  end

  @impl true
  def handle_event("issue_hold", %{"reach" => reach, "fix" => fix, "minutes" => minutes}, socket)
      when fix in @fixes do
    hold = {:hijaz_hold, fix: fix, minutes: String.to_integer(minutes), reach: reach}

    with {:ok, deliver} <- Map.fetch(reaches(), reach),
         :ok <- deliver.(@pubsub, @topic, hold) do
      {:noreply, assign(socket, :last_reach, reach)}
    else
      :error ->
        {:noreply, put_flash(socket, :error, "No such reach on the Hijaz wire")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Hold not sent: #{inspect(reason)}")}
    end
  end

  def handle_event("issue_hold", %{"fix" => fix}, socket) do
    {:noreply, put_flash(socket, :error, "#{fix} is not a Hijaz holding fix")}
  end

  @impl true
  def handle_info({:hijaz_hold, details}, socket) do
    line =
      "Hold #{details[:fix]} #{details[:minutes]} min via #{Keyword.get(details, :reach, "outside")}"

    {:noreply, update(socket, :holds, &[line | &1])}
  end

  defp reaches do
    %{
      "cluster" => &PubSub.broadcast/3,
      "node" => &PubSub.local_broadcast/3,
      "direct" => &PubSub.direct_broadcast(PubSub.node_name(&1), &1, &2, &3),
      "riyadh" => &PubSub.direct_broadcast(:"riyadh-acc@hijaz", &1, &2, &3)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 11 · Madinah Hijaz hold wire
      </p>
      <header class="masthead">
        <h1>Madinah Hijaz hold wire</h1>
        <p class="lede">
          {@clerk} stacks Hajj arrivals over the Hijaz fixes at Prince Mohammad bin Abdulaziz.
          This bottle runs one node, so cluster, node, and direct reaches land on the same desks.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>This node</dt>
        <dd id="node-name">{inspect(@node_name)}</dd>
        <dt>Connected nodes</dt>
        <dd id="connected-nodes">{length(@connected_nodes)}</dd>
      </dl>

      <form id="hold-form" phx-submit="issue_hold" class="scenario my-6 flex flex-wrap gap-3">
        <select id="hold-fix" name="fix" class="rounded-lg border border-stone-400 px-3 py-2">
          <option :for={fix <- @fixes} value={fix}>{fix}</option>
        </select>
        <input
          id="hold-minutes"
          name="minutes"
          type="number"
          value="12"
          class="w-24 rounded-lg border border-stone-400 px-3 py-2"
        />
        <select id="hold-reach" name="reach" class="rounded-lg border border-stone-400 px-3 py-2">
          <option value="cluster">Whole cluster</option>
          <option value="node">This node only</option>
          <option value="direct">This node by name</option>
          <option value="riyadh">Riyadh ACC node</option>
        </select>
        <button
          id="issue-hold"
          type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800"
        >
          Issue hold
        </button>
      </form>

      <p :if={@last_reach} id="last-reach">Last hold went out on the {@last_reach} reach</p>
      <ol id="hold-log" class="watch-log">
        <li :for={line <- @holds}>{line}</li>
      </ol>
    </Layouts.app>
    """
  end
end
