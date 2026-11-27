# Presence · 11 · Helsinki Malmi menders
#
# Teaches:
# - Counting without listing: one Enum.reduce/3 over Presence.list/1 keeps only integers, never the metas.
# - Keys count people and metas count screens, so a mender with two tablets counts once per trade.
# - A shift lead's page observes without tracking; cond grades the hangar from the tallies.

defmodule PhoenixMultivitaminWeb.HelsinkiMalmiMendersLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:malmi-hangar-2"
  @trades ~w(airframe avionics powerplant)

  @impl true
  def mount(params, _session, socket) do
    viewer =
      case params do
        %{"mender" => mender, "trade" => trade} when trade in @trades -> {:mender, mender, trade}
        %{"mender" => mender} -> {:mender, mender, "airframe"}
        _observer -> {:shift_lead, "Tuula"}
      end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

      with {:mender, mender, trade} <- viewer do
        {:ok, _ref} = Presence.track(self(), @topic, mender, %{trade: trade})
      end
    end

    {:ok,
     socket
     |> assign_scenario("Helsinki Malmi menders", elem(viewer, 1), "DHC-2 Beaver")
     |> assign(:tracked?, match?({:mender, _, _}, viewer))
     |> assign_tally()}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, assign_tally(socket)}

  defp assign_tally(socket) do
    empty = %{menders: 0, screens: 0, trades: Map.new(@trades, &{&1, 0})}

    tally =
      @topic
      |> Presence.list()
      |> Enum.reduce(empty, fn {_mender, %{metas: [first | _] = metas}}, acc ->
        %{
          acc
          | menders: acc.menders + 1,
            screens: acc.screens + length(metas),
            trades: Map.update(acc.trades, first.trade, 1, &(&1 + 1))
        }
      end)

    assign(socket, tally: tally, hangar: grade(tally))
  end

  defp grade(%{trades: %{"powerplant" => 0}}),
    do: {:grounded, "No powerplant mechanic: engine runs stop."}

  defp grade(%{menders: menders, trades: trades}) do
    cond do
      menders < 3 -> {:thin, "Thin shift: inspections only."}
      trades["avionics"] == 0 -> {:thin, "No avionics: radio work waits."}
      true -> {:staffed, "Hangar 2 is staffed for the Beaver's annual."}
    end
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :trades, @trades)

    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 11 · Helsinki Malmi menders
      </p>

      <h1>Helsinki Malmi menders</h1>
      <p class="lede">
        {@clerk} runs Hangar 2 at Malmi, where a {@craft} is in for its annual. The board counts
        menders and screens by trade without keeping anyone's metas.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p :if={!@tracked?} id="observer-note">Shift lead view: you are not counted.</p>
      <p id="hangar-grade" class={"grade-#{elem(@hangar, 0)}"} role="status">{elem(@hangar, 1)}</p>

      <dl id="hangar-tally" class="scenario mt-6 grid grid-cols-2 gap-2">
        <dt>Menders</dt>
        <dd id="tally-menders">{@tally.menders}</dd>
        <dt>Screens</dt>
        <dd id="tally-screens">{@tally.screens}</dd>
        <%= for trade <- @trades do %>
          <dt>{String.capitalize(trade)}</dt>
          <dd id={"tally-#{trade}"}>{@tally.trades[trade]}</dd>
        <% end %>
      </dl>
    </Layouts.app>
    """
  end
end
