# Testing · 07 · Launceston tower channel
#
# Teaches:
# - The catalog page explains the ChannelCase socket; the lesson is the test

defmodule PhoenixMultivitaminWeb.LauncestonTowerChannelLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Launceston tower channel", "Nerida", "Saab 340")
     |> assign(:topic, "tower:14")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 07 · Launceston tower channel
      </p>

      <h1>Launceston tower channel</h1>
      <p class="lede">
        Clerk {@clerk} joins {@topic} for the {@craft}. ChannelCase connects the
        Tamar socket, joins, pushes, and asserts replies and broadcasts.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="topic-name">{@topic}</p>
      <p id="socket-path">/features/25-testing/07-launceston-tower-channel/socket</p>
    </Layouts.app>
    """
  end
end
