# Presence · 09 · Riga Daugava operators
#
# Teaches:
# - A fetch/2 override overlays roster profiles onto presences in one batched lookup, keeping metas small.
# - The overlay reaches list/1 and both sides of every presence_diff, so the arrivals ticker names who left.
# - An unrostered licence gets a nil profile, which a function head turns into a visible warning.

defmodule PhoenixMultivitaminWeb.RigaDaugavaOperatorsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.RigaDaugavaPresence, as: OpsPresence

  @topic "presence:riga-ops-control"

  @impl true
  def mount(params, _session, socket) do
    licence = params["licence"] || "LV-OCC-4420"

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

      {:ok, _ref} =
        OpsPresence.track(self(), @topic, licence, %{console: params["console"] || "OCC-1"})
    end

    {:ok,
     socket
     |> assign_scenario("Riga Daugava operators", licence, "airBaltic A220-300")
     |> assign(:ticker, [])
     |> assign_operators()}
  end

  @impl true
  def handle_info(
        %Broadcast{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        socket
      ) do
    arrivals =
      for {licence, presence} <- joins, not Map.has_key?(leaves, licence), do: {:joined, presence}

    departures =
      for {licence, presence} <- leaves, not Map.has_key?(joins, licence), do: {:left, presence}

    {:noreply,
     socket
     |> update(:ticker, &Enum.take(arrivals ++ departures ++ &1, 6))
     |> assign_operators()}
  end

  defp assign_operators(socket) do
    operators =
      @topic |> OpsPresence.list() |> Enum.sort_by(fn {licence, _presence} -> licence end)

    assign(socket, :operators, operators)
  end

  defp operator_name(%{profile: %{name: name}}), do: name
  defp operator_name(%{profile: nil}), do: "Unrostered licence"

  defp ticker_line({:joined, presence}), do: "#{operator_name(presence)} joined the ops room"
  defp ticker_line({:left, presence}), do: "#{operator_name(presence)} left the ops room"

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 09 · Riga Daugava operators
      </p>

      <h1>Riga Daugava operators</h1>
      <p class="lede">
        Licence {@clerk} opens the Riga operations room while an {@craft} waits for a crew swap.
        Names, desks, and languages come from the roster in one lookup per presence change.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <table id="ops-room" class="scenario mt-6">
        <tr :for={{licence, presence} <- @operators} id={"operator-#{licence}"}>
          <th>{licence}</th>
          <td class="operator-name">{operator_name(presence)}</td>
          <td :if={presence.profile}>{presence.profile.desk}</td>
          <td :if={presence.profile}>{Enum.join(presence.profile.languages, " / ")}</td>
          <td :if={is_nil(presence.profile)} class="unrostered">
            Check licence with the duty manager
          </td>
        </tr>
      </table>

      <ul id="ops-ticker" class="watch-log mt-6">
        <li :for={event <- @ticker}>{ticker_line(event)}</li>
      </ul>
    </Layouts.app>
    """
  end
end
