# Auth and scopes · 12 · Arica Morro scope
#
# Teaches:
# - Role/permission checks on the scope via can?/2
# - Marshaller Diego clears the runway; clerk Pilar cannot
# - Wrong-station scope (Tacna) refused for the Arica board

defmodule PhoenixMultivitaminWeb.AricaMorroScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.MorroAuth
  alias PhoenixMultivitaminWeb.MorroScope

  @impl true
  def mount(_params, session, socket) do
    raw_scope = MorroScope.for_badge(session["morro_badge"])

    {scope, board, board_error} =
      case MorroAuth.open_arica_board(raw_scope) do
        {:ok, scope} -> {scope, :open, nil}
        {:error, :forbidden} when is_nil(raw_scope) -> {nil, :locked, nil}
        {:error, :forbidden} -> {raw_scope, :forbidden, :wrong_station}
      end

    {:ok,
     socket
     |> assign_scenario("Arica Morro scope", clerk_label(scope, raw_scope), "Cessna 172 Skyhawk")
     |> assign(:current_scope, scope)
     |> assign(:raw_scope, raw_scope)
     |> assign(:board, board)
     |> assign(:board_error, board_error)
     |> assign(:runway, :occupied)
     |> assign(:runway_message, nil)}
  end

  @impl true
  def handle_event("clear_runway", _params, socket) do
    case MorroAuth.clear_runway(socket.assigns.current_scope) do
      {:ok, :runway_cleared} ->
        {:noreply,
         socket
         |> assign(:runway, :cleared)
         |> assign(:runway_message, "Diego cleared runway 02 at ARI")}

      {:error, :forbidden} ->
        {:noreply,
         socket
         |> assign(:runway, :occupied)
         |> assign(:runway_message, "Marshaller role required to clear the runway")
         |> put_flash(:error, "Forbidden")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 12 · Arica Morro scope
      </p>

      <h1>Arica Morro scope</h1>
      <p class="lede">
        Marshaller Diego and clerk Pilar share the Morro cliff VFR desk at
        Arica (ARI). Permissions live on the scope, not the template.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= cond do %>
        <% @board == :open and match?(%MorroScope{}, @current_scope) -> %>
          <dl id="morro-board" class="station-meta">
            <dt>Name</dt>
            <dd id="scope-name">{@current_scope.name}</dd>
            <dt>Role</dt>
            <dd id="scope-role">{@current_scope.role}</dd>
            <dt>Station</dt>
            <dd id="scope-station">{@current_scope.station}</dd>
            <dt>Can clear runway</dt>
            <dd id="can-clear">{yes_no(MorroAuth.can?(@current_scope, :clear_runway))}</dd>
          </dl>

          <button id="clear-runway" type="button" phx-click="clear_runway">
            Clear runway 02
          </button>
        <% @board == :forbidden -> %>
          <p id="wrong-station" class="muted">
            Forbidden. Scope for {@raw_scope.station} cannot open the Arica board
            (tried Tacna).
          </p>
        <% true -> %>
          <p id="morro-locked" class="muted">
            Morro desk locked. Clip a Diego or Pilar badge for ARI.
          </p>
      <% end %>

      <p id="runway-state">{runway_label(@runway)}</p>
      <p :if={@runway_message} id="runway-message">{@runway_message}</p>
    </Layouts.app>
    """
  end

  defp clerk_label(%MorroScope{name: name}, _), do: name
  defp clerk_label(nil, %MorroScope{name: name}), do: name
  defp clerk_label(_, _), do: "Diego"

  defp yes_no(true), do: "yes"
  defp yes_no(false), do: "no"

  defp runway_label(:cleared), do: "cleared"
  defp runway_label(:occupied), do: "occupied"
end
