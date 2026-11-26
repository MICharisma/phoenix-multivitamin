# Auth and scopes · 13 · Cartagena walled scope
#
# Teaches:
# - Capstone: fetch scope plug, on_mount require, scoped context
# - Session renewal, logout broadcast, refused board for wrong station
# - Mix of prior techniques kept readable

defmodule PhoenixMultivitaminWeb.CartagenaWalledScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.WalledAuth
  alias PhoenixMultivitaminWeb.WalledHarbour
  alias PhoenixMultivitaminWeb.WalledScope

  on_mount {WalledAuth, :require}

  @impl true
  def mount(_params, _session, socket) do
    scope = socket.assigns.current_scope

    {slips, board} =
      case {WalledHarbour.list_harbour_slips(scope), scope} do
        {{:ok, slips}, _} -> {slips, :open}
        {{:error, :forbidden}, %WalledScope{}} -> {[], :wrong_station}
        {{:error, :forbidden}, _} -> {[], :locked}
      end

    socket =
      socket
      |> assign_scenario("Cartagena walled scope", "Catalina", "DHC-6 Twin Otter")
      |> assign(:slips, slips)
      |> assign(:board, board)
      |> assign(:signed_out?, false)
      |> assign(:renew_message, nil)

    socket =
      if connected?(socket) and match?(%WalledScope{station: "CTG"}, scope) do
        :ok = WalledAuth.subscribe(scope)
        assign(socket, :subscribed?, true)
      else
        assign(socket, :subscribed?, false)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("renew_session", _params, socket) do
    socket =
      case socket.assigns.current_scope do
        %WalledScope{station: "CTG"} = scope ->
          renewed = WalledAuth.renew_scope(scope)

          socket
          |> assign(:current_scope, renewed)
          |> assign(:renew_message, "Harbour session renewed for Catalina")

        _ ->
          put_flash(socket, :error, "No CTG scope to renew")
      end

    {:noreply, socket}
  end

  def handle_event("sign_out_harbour", _params, socket) do
    case socket.assigns.current_scope do
      %WalledScope{station: "CTG"} = scope ->
        :ok = WalledAuth.broadcast_logout(scope)
        {:noreply, socket}

      _ ->
        {:noreply, put_flash(socket, :error, "Already clear of the harbour desk")}
    end
  end

  @impl true
  def handle_info({:walled_logout, "CTG"}, socket) do
    {:noreply,
     socket
     |> assign(:current_scope, nil)
     |> assign(:board, :locked)
     |> assign(:slips, [])
     |> assign(:signed_out?, true)
     |> assign(:subscribed?, false)
     |> put_flash(:info, "Signed out of Cartagena harbour")}
  end

  def handle_info({:walled_logout, _other}, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Auth and scopes · 13 · Cartagena walled scope
      </p>

      <h1>Cartagena walled scope</h1>
      <p class="lede">
        Clerk {@clerk} runs the walled-harbour seaplane desk at Cartagena (CTG)
        for a {@craft}. Plug, on_mount, scoped context, renew, and logout.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= cond do %>
        <% @board == :open -> %>
          <dl id="walled-board" class="station-meta">
            <dt>Clerk</dt>
            <dd id="scope-clerk">{@current_scope.clerk}</dd>
            <dt>Station</dt>
            <dd id="scope-station">{@current_scope.station}</dd>
            <dt>Authenticated at</dt>
            <dd id="authenticated-at">{DateTime.to_iso8601(@current_scope.authenticated_at)}</dd>
            <dt>Topic</dt>
            <dd id="harbour-topic">{WalledAuth.topic(@current_scope)}</dd>
          </dl>

          <ul id="harbour-slips">
            <li :for={slip <- @slips} id={slip.id}>{slip.name}</li>
          </ul>

          <div id="harbour-actions">
            <button id="renew-session" type="button" phx-click="renew_session">
              Renew session
            </button>
            <button id="sign-out-harbour" type="button" phx-click="sign_out_harbour">
              Sign out harbour
            </button>
          </div>

          <p :if={@renew_message} id="renew-message">{@renew_message}</p>
        <% @board == :wrong_station -> %>
          <p id="wrong-station" class="muted">
            Refused. {@current_scope.station} scope cannot list CTG harbour slips.
          </p>
        <% true -> %>
          <p id="harbour-locked" class="muted">
            <%= if @signed_out? do %>
              Signed out. The walled harbour desk is clear.
            <% else %>
              Harbour locked. Present Catalina's CTG session.
            <% end %>
          </p>
      <% end %>
    </Layouts.app>
    """
  end
end
