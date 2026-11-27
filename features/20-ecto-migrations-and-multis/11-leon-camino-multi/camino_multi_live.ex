# Ecto migrations and multis · 11 · León Camino multi
#
# Teaches:
# - Multi.merge/2 joins a leg Multi and a stamp Multi
# - Pattern match on {:ok, %{leg: _, stamp: _}} after the walk

defmodule PhoenixMultivitaminWeb.LeonCaminoMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.LeonCaminoDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("León Camino multi", "Froilán", "Pilatus PC-12")
     |> assign(:from_icao, nil)
     |> assign(:stamp, nil)
     |> assign(
       :form,
       to_form(%{"from_icao" => "LEN", "to_icao" => "SCQ", "stamp" => "hospitales"}, as: :walk)
     )}
  end

  @impl true
  def handle_event("walk_leg", %{"walk" => params}, socket) do
    socket =
      case LeonCaminoDesk.walk_leg(
             Map.get(params, "from_icao", ""),
             Map.get(params, "to_icao", ""),
             Map.get(params, "stamp", "")
           ) do
        {:ok, %{leg: leg, stamp: stamp}} ->
          socket
          |> assign(:from_icao, leg.from_icao)
          |> assign(:stamp, stamp.stamp)

        {:error, _step, _value, _changes} ->
          put_flash(socket, :error, "Could not walk the Camino leg")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto migrations and multis · 11 · León Camino multi
      </p>

      <h1>León Camino multi</h1>
      <p class="lede">
        Clerk {@clerk} walks a {@craft} Camino leg from León. Two smaller
        Multis merge into one transaction.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@from_icao} id="walked-from">{@from_icao}</p>
      <p :if={@stamp} id="walked-stamp">{@stamp}</p>

      <.form for={@form} id="walk-form" phx-submit="walk_leg">
        <.input field={@form[:from_icao]} label="From ICAO" />
        <.input field={@form[:to_icao]} label="To ICAO" />
        <.input field={@form[:stamp]} label="Stamp" />
        <.button id="walk-leg" type="submit">Walk the leg</.button>
      </.form>
    </Layouts.app>
    """
  end
end
