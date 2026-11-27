# Presence · 04 · Dubrovnik walls crew
#
# Teaches:
# - The presence key is the apron stand, not a person, so every agent's meta merges under one key.
# - An enforced-key struct summarizes each stand; a separate String.Chars implementation prints its crew roll.
# - MapSet.difference/2 compares the metas' roles with the roles a turnaround needs.

defmodule PhoenixMultivitaminWeb.DubrovnikWallsCrewLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.DubrovnikStandCrew, as: StandCrew
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:dubrovnik-apron"
  @roles ~w(marshaller loader fueller)

  @impl true
  def mount(params, _session, socket) do
    %{"agent" => agent, "stand" => stand, "role" => role} =
      Map.merge(%{"agent" => "Ivana", "stand" => "4", "role" => "marshaller"}, params)

    socket = assign_scenario(socket, "Dubrovnik walls crew", agent, "Croatia Airlines A220-300")

    cond do
      role not in @roles ->
        {:ok, socket |> put_flash(:error, "#{role} is not a turnaround role.") |> assign_stands()}

      connected?(socket) ->
        Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
        {:ok, _ref} = Presence.track(self(), @topic, stand, %{agent: agent, role: role})
        {:ok, assign_stands(socket)}

      true ->
        {:ok, assign_stands(socket)}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, assign_stands(socket)}

  defp assign_stands(socket) do
    stands =
      @topic
      |> Presence.list()
      |> Enum.map(&StandCrew.from_presence/1)
      |> Enum.sort_by(&{String.length(&1.stand), &1.stand})

    assign(socket, :stands, stands)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 04 · Dubrovnik walls crew
      </p>

      <h1>Dubrovnik walls crew</h1>
      <p class="lede">
        Ramp lead {@clerk} checks which apron stands have a full turnaround crew before the {@craft} blocks in from Zagreb.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ul id="apron-stands" class="scenario watch-log mt-6">
        <li :for={crew <- @stands} id={"stand-#{crew.stand}"}>
          <p>{to_string(crew)}</p>
          <p :if={StandCrew.missing_roles(crew) == []} class="stand-ready">Ready for turnaround</p>
          <p :if={StandCrew.missing_roles(crew) != []} class="stand-missing">
            Missing: {Enum.join(StandCrew.missing_roles(crew), ", ")}
          </p>
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
