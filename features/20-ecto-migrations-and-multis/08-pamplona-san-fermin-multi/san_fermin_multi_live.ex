# Ecto migrations and multis · 08 · Pamplona San Fermín multi
#
# Teaches:
# - Multi.run/3 computes a gate fee that is not a schema insert
# - Guarded desk heads reject non-positive litres before Multi starts

defmodule PhoenixMultivitaminWeb.PamplonaSanFerminMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.PamplonaFerminDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Pamplona San Fermín multi", "Ainhoa", "Embraer E190")
     |> assign(:stand, nil)
     |> assign(:gate_fee_eur, nil)
     |> assign(:form, to_form(%{"stand" => "SF-3", "litres" => "4500"}, as: :plate))}
  end

  @impl true
  def handle_event("stamp_plate", %{"plate" => params}, socket) do
    litres =
      case Integer.parse(Map.get(params, "litres", "")) do
        {value, _} -> value
        :error -> 0
      end

    socket =
      case PamplonaFerminDesk.stamp_plate(Map.get(params, "stand", ""), litres) do
        {:ok, %{plated: plate, gate_fee: fee}} ->
          socket
          |> assign(:stand, plate.stand)
          |> assign(:gate_fee_eur, fee)

        {:error, :litres_not_positive} ->
          put_flash(socket, :error, "Litres must be positive")

        {:error, _step, _value, _changes} ->
          put_flash(socket, :error, "Could not stamp the plate")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 08 · Pamplona San Fermín multi
      </p>

      <h1>Pamplona San Fermín multi</h1>
      <p class="lede">
        Clerk {@clerk} stamps a {@craft} plate at Pamplona. A <code>Multi.run/3</code>
        step prices the gate fee before the update.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@stand} id="stamped-stand">{@stand}</p>
      <p :if={@gate_fee_eur} id="gate-fee">{@gate_fee_eur}</p>

      <.form for={@form} id="plate-form" phx-submit="stamp_plate">
        <.input field={@form[:stand]} label="Stand" />
        <.input field={@form[:litres]} type="number" label="Litres" />
        <.button id="stamp-plate" type="submit">Stamp the plate</.button>
      </.form>
    </Layouts.app>
    """
  end
end
