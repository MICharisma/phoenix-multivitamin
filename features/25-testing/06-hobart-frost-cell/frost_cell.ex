# Testing · 06 · Hobart frost cell
#
# Teaches:
# - A stateful LiveComponent keeps taps under its own id
# - phx-target={@myself} routes clicks to the cell, not the parent

defmodule PhoenixMultivitaminWeb.HobartFrostCell do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, taps: 0, last_note: nil)}
  end

  @impl true
  def update(%{note: note} = assigns, socket) when is_binary(note) do
    {:ok,
     socket
     |> assign(Map.take(assigns, [:id, :clerk, :craft]))
     |> assign(:last_note, note)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, Map.take(assigns, [:id, :clerk, :craft]))}
  end

  @impl true
  def handle_event("tap_frost", _params, socket) do
    taps = socket.assigns.taps + 1
    send(self(), {:frost_tapped, taps})
    {:noreply, assign(socket, :taps, taps)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <p id="cell-clerk">{@clerk}</p>
      <p id="cell-craft">{@craft}</p>
      <p id="frost-taps">{@taps}</p>
      <p :if={@last_note} id="frost-note">{@last_note}</p>
      <button id="tap-frost" type="button" phx-click="tap_frost" phx-target={@myself}>
        Tap frost
      </button>
    </div>
    """
  end
end
