# Telemetry and LiveDashboard · 11 · Toamasina vanilla gauge
#
# Teaches:
# - LiveView emits [:phoenix, :live_view, :mount] and [:phoenix, :live_view, :handle_event]
#   as spans (start/stop)
# - A simple board event appends domain rows while those spans fire underneath

defmodule PhoenixMultivitaminWeb.ToamasinaVanillaGaugeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Toamasina vanilla gauge", "Fara", "Twin Otter")
     |> assign(:port, "Toamasina")
     |> assign(:island, "Madagascar")
     |> assign(:crates, [])
     |> assign(:crate_count, 0)}
  end

  @impl true
  def handle_event("log_vanilla_crate", %{"lot" => lot}, socket) when byte_size(lot) > 0 do
    crate = build_crate(lot)

    {:noreply,
     socket
     |> update(:crates, &[crate | &1])
     |> update(:crate_count, &(&1 + 1))}
  end

  def handle_event("log_vanilla_crate", _params, socket) do
    {:noreply, put_flash(socket, :error, "Fara needs a vanilla lot before logging a crate.")}
  end

  def handle_event("clear_vanilla_board", _params, socket) do
    cleared? = socket.assigns.crate_count > 0

    socket =
      cond do
        cleared? ->
          socket
          |> assign(:crates, [])
          |> assign(:crate_count, 0)

        true ->
          put_flash(socket, :error, "The Toamasina board is already empty.")
      end

    {:noreply, socket}
  end

  defp build_crate(lot) do
    %{
      lot: lot,
      dom_id: "crate-" <> String.replace(lot, ~r/[^A-Za-z0-9]+/, "-"),
      beans_kg: crate_weight(lot),
      logged_at: Time.utc_now() |> Time.truncate(:second)
    }
  end

  defp crate_weight("Sambava A"), do: 12.5
  defp crate_weight("Antalaha B"), do: 9.0
  defp crate_weight(lot), do: lot |> String.length() |> Kernel.*(0.5)

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Telemetry and LiveDashboard · 11 · Toamasina vanilla gauge
      </p>

      <h1>Toamasina vanilla gauge</h1>
      <p class="lede">
        {@clerk} logs vanilla crates at {@port} on {@island} before the Twin Otter
        hops inland. LiveView mount and handle_event run as telemetry spans
        (<code>start</code>/<code>stop</code>).
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="watch-switcher">
        <button
          id="log-sambava"
          type="button"
          phx-click="log_vanilla_crate"
          phx-value-lot="Sambava A"
        >
          Log Sambava A crate
        </button>
        <button
          id="log-antalaha"
          type="button"
          phx-click="log_vanilla_crate"
          phx-value-lot="Antalaha B"
        >
          Log Antalaha B crate
        </button>
        <button id="log-empty-lot" type="button" phx-click="log_vanilla_crate" phx-value-lot="">
          Refuse empty lot
        </button>
        <button id="clear-board" type="button" phx-click="clear_vanilla_board">
          Clear board
        </button>
      </div>

      <p id="crate-count">Crates logged: {@crate_count}</p>

      <div id="crate-log" class="scenario">
        <h2>Vanilla crates</h2>
        <p :if={@crates == []} id="empty-crates">No vanilla crate logged yet.</p>
        <ul>
          <li :for={crate <- @crates} id={crate.dom_id}>
            {crate.lot}: {crate.beans_kg} kg at {crate.logged_at}
          </li>
        </ul>
      </div>
    </Layouts.catalog>
    """
  end
end
