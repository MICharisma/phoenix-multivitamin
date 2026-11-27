# Presence · 02 · Heraklion Knossos presence
#
# Teaches:
# - Presence.list/1 flattened into {position, controller} pairs and grouped with Enum.group_by/3.
# - Presence.get_by_key/2 answers one question (is the duty supervisor on watch?) without listing the tower.
# - get_by_key/2 returns `[]` for an absent key and a `%{metas: [...]}` map for a present one; a case covers both.

defmodule PhoenixMultivitaminWeb.HeraklionKnossosPresenceLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:heraklion-tower"
  @positions ~w(tower ground delivery supervisor)
  @duty_supervisor "Eleni"

  @impl true
  def mount(%{"controller" => controller} = params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
      {:ok, _ref} = Presence.track(self(), @topic, controller, %{position: position(params)})
    end

    {:ok,
     socket
     |> assign_scenario("Heraklion Knossos presence", controller, "Aegean A321neo")
     |> refresh_tower()}
  end

  def mount(params, session, socket) do
    mount(Map.put(params, "controller", "Giorgos"), session, socket)
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, refresh_tower(socket)}

  defp position(%{"position" => position}) when position in @positions, do: position
  defp position(_params), do: "ground"

  defp refresh_tower(socket) do
    staffing =
      @topic
      |> Presence.list()
      |> Enum.flat_map(fn {controller, %{metas: metas}} ->
        Enum.map(metas, &{&1.position, controller})
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    assign(socket,
      staffing: staffing,
      supervisor_watch: supervisor_watch(Presence.get_by_key(@topic, @duty_supervisor))
    )
  end

  defp supervisor_watch([]), do: {:absent, @duty_supervisor}

  defp supervisor_watch(%{metas: [%{position: position} | _]}),
    do: {:on_watch, @duty_supervisor, position}

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :positions, @positions)

    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 02 · Heraklion Knossos presence
      </p>

      <h1>Heraklion Knossos presence</h1>
      <p class="lede">
        {@clerk} plugs in at Heraklion tower before the morning {@craft} wave from Athens. The
        position board groups every connected controller by the position they are working.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <p id="supervisor-watch" role="status">
        <%= case @supervisor_watch do %>
          <% {:on_watch, name, position} -> %>
            Duty supervisor {name} is on watch at {position}.
          <% {:absent, name} -> %>
            Duty supervisor {name} has not plugged in. Hold the runway change.
        <% end %>
      </p>

      <div class="scenario mt-6 grid gap-4 sm:grid-cols-2">
        <section :for={position <- @positions} id={"position-#{position}"}>
          <h2>{String.capitalize(position)}</h2>
          <p :if={Map.get(@staffing, position, []) == []} class="text-stone-500">Unstaffed</p>
          <p :for={controller <- Map.get(@staffing, position, [])} data-controller={controller}>
            {controller}
          </p>
        </section>
      </div>
    </Layouts.app>
    """
  end
end
