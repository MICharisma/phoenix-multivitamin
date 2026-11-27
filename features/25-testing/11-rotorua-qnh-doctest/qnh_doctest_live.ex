# Testing · 11 · Rotorua QNH doctest
#
# Teaches:
# - The catalog page runs parse/1; the doctests are the lesson

defmodule PhoenixMultivitaminWeb.RotoruaQnhDoctestLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.RotoruaQnh

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Rotorua QNH doctest", "Aroha", "Squirrel AS350")
     |> assign(:label, nil)
     |> assign(:error, nil)}
  end

  @impl true
  def handle_event("parse_qnh", %{"qnh" => raw}, socket) do
    socket =
      case RotoruaQnh.parse(raw) do
        {:ok, qnh} ->
          socket
          |> assign(:label, RotoruaQnh.label(qnh))
          |> assign(:error, nil)

        {:error, reason} ->
          socket
          |> assign(:label, nil)
          |> assign(:error, reason)
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 11 · Rotorua QNH doctest
      </p>

      <h1>Rotorua QNH doctest</h1>
      <p class="lede">
        Clerk {@clerk} parses steam-field QNH for the {@craft}. The real lesson
        is <code>doctest PhoenixMultivitamin.RotoruaQnh</code> in the test file.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <form id="qnh-form" phx-submit="parse_qnh">
        <input id="qnh-input" type="text" name="qnh" value="1013" />
        <button id="parse-qnh" type="submit">Parse QNH</button>
      </form>

      <p :if={@label} id="qnh-label">{@label}</p>
      <p :if={@error} id="qnh-error">{@error}</p>
    </Layouts.app>
    """
  end
end
