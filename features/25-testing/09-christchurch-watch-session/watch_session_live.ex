# Testing · 09 · Christchurch watch session
#
# Teaches:
# - mount/3 reads the controller name from the session
# - ConnTest init_test_session/2 seeds the session before live/2

defmodule PhoenixMultivitaminWeb.ChristchurchWatchSessionLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    controller = Map.get(session, "plains_controller", "relief")

    {:ok,
     socket
     |> assign_scenario("Christchurch watch session", controller, "ATR 72")
     |> assign(:watch, watch_for(controller))
     |> assign(:session_seeded?, Map.has_key?(session, "plains_controller"))}
  end

  defp watch_for("Aroha"), do: "evening"
  defp watch_for("Tane"), do: "midwatch"
  defp watch_for(_), do: "relief"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 09 · Christchurch watch session
      </p>

      <h1>Christchurch watch session</h1>
      <p class="lede">
        The Plains controller arrives in the session, not the URL. Tests seed it
        with <code>init_test_session/2</code> before <code>live/2</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="watch-name">{@watch}</p>
      <p id="session-seeded">{@session_seeded?}</p>
    </Layouts.app>
    """
  end
end
