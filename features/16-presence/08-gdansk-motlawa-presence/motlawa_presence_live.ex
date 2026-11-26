# Presence · 08 · Gdańsk Motława presence
#
# Teaches:
# - Two tabs tracking the same key produce one presence with two metas, not two people.
# - Closing one tab removes only its meta; the dispatcher stays present until the last tab closes.
# - A for comprehension with two generators and reduce: inverts presences into a device index.

defmodule PhoenixMultivitaminWeb.GdanskMotlawaPresenceLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:gdansk-ops-dispatch"
  @devices %{"desk" => "ops desk", "tablet" => "apron tablet", "phone" => "duty phone"}

  @impl true
  def mount(params, _session, socket) do
    dispatcher = params["dispatcher"] || "Hanna"
    device = Map.get(@devices, params["device"], "ops desk")

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
      {:ok, _ref} = Presence.track(self(), @topic, dispatcher, %{device: device})
    end

    {:ok,
     socket
     |> assign_scenario("Gdańsk Motława presence", dispatcher, "Wizz Air A321neo")
     |> assign(:device, device)
     |> assign_dispatch()}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, assign_dispatch(socket)}

  defp assign_dispatch(socket) do
    presences = Presence.list(@topic)

    dispatchers =
      presences
      |> Enum.map(fn {name, %{metas: metas}} ->
        %{name: name, devices: Enum.map(metas, & &1.device)}
      end)
      |> Enum.sort_by(&{-length(&1.devices), &1.name})

    by_device =
      for {name, %{metas: metas}} <- presences, %{device: device} <- metas, reduce: %{} do
        index -> Map.update(index, device, [name], &Enum.uniq([name | &1]))
      end

    assign(socket, dispatchers: dispatchers, by_device: by_device)
  end

  defp screen_count([_only]), do: "1 screen"
  defp screen_count(devices), do: "#{length(devices)} screens"

  defp slug(text), do: text |> String.downcase() |> String.replace(" ", "-")

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 08 · Gdańsk Motława presence
      </p>

      <h1>Gdańsk Motława presence</h1>
      <p class="lede">
        Dispatcher {@clerk} follows the {@craft} turnaround at Gdańsk from the {@device} and often
        from a second screen. Each dispatcher is listed once, with every screen they have open.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ul id="dispatchers" class="scenario watch-log mt-6">
        <li :for={dispatcher <- @dispatchers} id={"dispatcher-#{slug(dispatcher.name)}"}>
          <strong>{dispatcher.name}</strong>
          <span class="screen-count">{screen_count(dispatcher.devices)}</span>
          · {Enum.join(dispatcher.devices, ", ")}
        </li>
      </ul>

      <dl id="device-index" class="mt-6">
        <div :for={{device, names} <- Enum.sort(@by_device)} id={"device-#{slug(device)}"}>
          <dt>{device}</dt>
          <dd>{names |> Enum.sort() |> Enum.join(", ")}</dd>
        </div>
      </dl>
    </Layouts.app>
    """
  end
end
