# Presence · 05 · Split Diocletian watch
#
# Teaches:
# - Presence.list/1 seeds the roster once; every later presence_diff is folded in without listing again.
# - The view's own join diff arrives after the seeding list already holds it, so joins are de-duplicated by phx_ref.
# - Leaves are removed by phx_ref before joins are added, so a meta update (a leave and a join for one key) lands cleanly.
# - Multi-clause reducers with Enum.reduce/3 and Map.update/4 keep the merge a pure function of roster and diff.

defmodule PhoenixMultivitaminWeb.SplitDiocletianWatchLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:split-approach-watch"

  @impl true
  def mount(params, _session, socket) do
    controller = params["controller"] || "Ante"

    roster =
      if connected?(socket) do
        Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
        {:ok, _ref} = Presence.track(self(), @topic, controller, %{frequency: "119.100"})
        Map.new(Presence.list(@topic), fn {name, %{metas: metas}} -> {name, metas} end)
      else
        %{}
      end

    {:ok,
     socket
     |> assign_scenario("Split Diocletian watch", controller, "Croatia Airlines Dash 8-Q400")
     |> assign(roster: roster, diffs_applied: 0)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: diff}, socket) do
    {:noreply,
     socket
     |> update(:roster, &merge_diff(&1, diff))
     |> update(:diffs_applied, &(&1 + 1))}
  end

  defp merge_diff(roster, %{joins: joins, leaves: leaves}) do
    roster = Enum.reduce(leaves, roster, &drop_leave/2)
    Enum.reduce(joins, roster, &add_join/2)
  end

  defp drop_leave({controller, %{metas: left}}, roster) do
    gone = MapSet.new(left, & &1.phx_ref)

    case Enum.reject(Map.get(roster, controller, []), &MapSet.member?(gone, &1.phx_ref)) do
      [] -> Map.delete(roster, controller)
      remaining -> Map.put(roster, controller, remaining)
    end
  end

  defp add_join({controller, %{metas: joined}}, roster) do
    Map.update(
      roster,
      controller,
      joined,
      &Enum.uniq_by(&1 ++ joined, fn meta -> meta.phx_ref end)
    )
  end

  defp frequencies(metas),
    do: metas |> Enum.map(& &1.frequency) |> Enum.uniq() |> Enum.join(" / ")

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 05 · Split Diocletian watch
      </p>

      <h1>Split Diocletian watch</h1>
      <p class="lede">
        {@clerk} holds Split Approach while a {@craft} descends over the old town. The watch roster
        is kept from presence diffs alone after the first list.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="diffs-applied">{@diffs_applied} presence diffs folded in</p>
      <dl id="watch-roster" class="scenario mt-6">
        <div
          :for={{controller, metas} <- Enum.sort(@roster)}
          id={"watch-#{String.downcase(controller)}"}
        >
          <dt>{controller}</dt>
          <dd>{frequencies(metas)}</dd>
        </div>
      </dl>
    </Layouts.app>
    """
  end
end
