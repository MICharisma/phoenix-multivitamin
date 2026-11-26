# Testing · 05 · Kalgoorlie wind async
#
# Teaches:
# - assign_async starts only on the connected mount
# - render_async/1 waits for the Goldfields wind without Process.sleep

defmodule PhoenixMultivitaminWeb.KalgoorlieWindAsyncLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_scenario("Kalgoorlie wind async", "Tarni", "King Air 350")
      |> assign(:pad, "Goldfields")

    socket =
      if connected?(socket) do
        assign_async(socket, :wind, fn ->
          {:ok, %{wind: goldfields_wind()}}
        end)
      else
        assign(socket, :wind, nil)
      end

    {:ok, socket}
  end

  defp goldfields_wind do
    "27018G26KT"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 05 · Kalgoorlie wind async
      </p>

      <h1>Kalgoorlie wind async</h1>
      <p class="lede">
        Clerk {@clerk} fetches {@pad} wind for the {@craft}. Tests wait with <code>render_async/1</code>, never <code>Process.sleep/1</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="pad-name">{@pad}</p>

      <%= if @wind do %>
        <.async_result :let={wind} assign={@wind}>
          <:loading>
            <p id="wind-loading">Wind still out on the Goldfields.</p>
          </:loading>
          <:failed>
            <p id="wind-failed">Wind fetch failed. Reopen Kalgoorlie to retry.</p>
          </:failed>
          <p id="wind-value">{wind}</p>
        </.async_result>
      <% else %>
        <p id="wind-static">Static mount. Goldfields wind waits for the socket.</p>
      <% end %>
    </Layouts.app>
    """
  end
end
