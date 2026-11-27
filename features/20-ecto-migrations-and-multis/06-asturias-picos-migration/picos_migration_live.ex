# Ecto migrations and multis · 06 · Asturias Picos migration
#
# Teaches:
# - execute/2 data migration SQL can be replayed from a context
# - Captures and frequencies_by summarise the backfilled phases

defmodule PhoenixMultivitaminWeb.AsturiasPicosMigrationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.AsturiasPicosDesk
  alias PhoenixMultivitamin.AsturiasPicosMigration

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Asturias Picos migration", "Covadonga", "Leonardo AW139")
     |> assign(:execute_documented, execute_documented?())
     |> assign(:tallies, %{})
     |> assign(:seeded, false)}
  end

  @impl true
  def handle_event("seed_legacy", _params, socket) do
    AsturiasPicosDesk.seed_legacy!([
      %{clerk: "Covadonga", craft: "Leonardo AW139", legacy_phase: "climb"},
      %{clerk: "Covadonga", craft: "Leonardo AW139", legacy_phase: "cruise"},
      %{clerk: "Covadonga", craft: "Leonardo AW139", legacy_phase: "climb"}
    ])

    {:noreply,
     socket
     |> assign(:seeded, true)
     |> assign(:tallies, AsturiasPicosDesk.phase_tallies())}
  end

  def handle_event("replay_backfill", _params, socket) do
    :ok = AsturiasPicosDesk.replay_backfill!()

    {:noreply, assign(socket, :tallies, AsturiasPicosDesk.phase_tallies())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 06 · Asturias Picos migration
      </p>

      <h1>Asturias Picos migration</h1>
      <p class="lede">
        Clerk {@clerk} replays the Picos de Europa phase backfill for the {@craft}. The migration used <code>execute/2</code>, not bare <code>execute/1</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="execute-documented">{@execute_documented}</p>
      <p id="seeded">{@seeded}</p>

      <button id="seed-legacy" type="button" phx-click="seed_legacy">Seed legacy phases</button>
      <button id="replay-backfill" type="button" phx-click="replay_backfill">
        Replay the backfill
      </button>

      <ul id="phase-tallies">
        <li :for={{phase, count} <- Enum.sort(@tallies)} id={"tally-#{phase}"}>
          {phase}: {count}
        </li>
      </ul>
    </Layouts.app>
    """
  end

  defp execute_documented? do
    {:ok, source} = File.read(AsturiasPicosMigration.__info__(:compile)[:source])

    String.contains?(source, "execute(") and
      String.contains?(source, "UPDATE asturias_picos_cards SET phase = 'unknown'")
  end
end
