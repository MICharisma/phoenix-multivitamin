# Auth and scopes · 11 · Iquique nitrate scope
#
# Teaches:
# - Scoped PubSub topics + logout broadcast
# - Subscribe on connected mount; post_nitrate_note broadcasts
# - sign_out_station broadcasts {:nitrate_logout, station_id}; handle_info clears scope

defmodule PhoenixMultivitaminWeb.IquiqueNitrateScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.NitrateBoards
  alias PhoenixMultivitaminWeb.NitrateScope

  @impl true
  def mount(_params, session, socket) do
    scope = scope_from_session(session)

    socket =
      socket
      |> assign_scenario("Iquique nitrate scope", "Valentina", "Basler BT-67")
      |> assign(:current_scope, scope)
      |> assign(:notes, [])
      |> assign(:signed_out?, false)

    socket =
      if connected?(socket) and match?(%NitrateScope{}, scope) do
        :ok = NitrateBoards.subscribe(scope)
        assign(socket, :subscribed?, true)
      else
        assign(socket, :subscribed?, false)
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("post_nitrate_note", %{"body" => body}, socket) do
    body = String.trim(body)

    socket =
      case socket.assigns.current_scope do
        %NitrateScope{} = scope when body != "" ->
          :ok = NitrateBoards.broadcast_note(scope, body)
          socket

        _ ->
          put_flash(socket, :error, "Nitrate scope required to post")
      end

    {:noreply, socket}
  end

  def handle_event("sign_out_station", _params, socket) do
    case socket.assigns.current_scope do
      %NitrateScope{} = scope ->
        :ok = NitrateBoards.broadcast_logout(scope)
        {:noreply, socket}

      nil ->
        {:noreply, put_flash(socket, :error, "Already signed out")}
    end
  end

  @impl true
  def handle_info({:nitrate_note, station_id, body}, socket) do
    note = %{id: "note-#{System.unique_integer([:positive])}", station_id: station_id, body: body}
    {:noreply, assign(socket, :notes, [note | socket.assigns.notes])}
  end

  def handle_info({:nitrate_logout, station_id}, socket) do
    socket =
      case socket.assigns.current_scope do
        %NitrateScope{station_id: ^station_id} ->
          socket
          |> assign(:current_scope, nil)
          |> assign(:signed_out?, true)
          |> assign(:subscribed?, false)
          |> put_flash(:info, "Signed out of Iquique nitrate hangar")

        _ ->
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Auth and scopes · 11 · Iquique nitrate scope
      </p>

      <h1>Iquique nitrate scope</h1>
      <p class="lede">
        Clerk {@clerk} posts on the nitrate-era hangar board at Iquique (IQQ)
        for a {@craft}. Notes and logout ride a scoped PubSub topic.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <%= if @current_scope do %>
        <dl id="nitrate-board" class="station-meta">
          <dt>Clerk</dt>
          <dd id="scope-clerk">{@current_scope.clerk}</dd>
          <dt>Station</dt>
          <dd id="scope-station">{@current_scope.station_id}</dd>
          <dt>Topic</dt>
          <dd id="pubsub-topic">{NitrateBoards.topic(@current_scope)}</dd>
          <dt>Subscribed</dt>
          <dd id="subscribed-state">{if @subscribed?, do: "yes", else: "no"}</dd>
        </dl>

        <form id="nitrate-note-form" phx-submit="post_nitrate_note">
          <input id="nitrate-note-body" type="text" name="body" placeholder="Hangar note" />
          <button id="post-nitrate-note" type="submit">Post nitrate note</button>
        </form>

        <button id="sign-out-station" type="button" phx-click="sign_out_station">
          Sign out station
        </button>
      <% else %>
        <p id="nitrate-locked" class="muted">
          <%= if @signed_out? do %>
            Signed out. The IQQ nitrate topic dropped this desk.
          <% else %>
            Nitrate hangar locked. Present Valentina's station session.
          <% end %>
        </p>
      <% end %>

      <ol id="nitrate-notes">
        <li :for={note <- @notes} id={note.id}>{note.body}</li>
      </ol>
    </Layouts.app>
    """
  end

  defp scope_from_session(%{"nitrate_clerk" => "Valentina"} = session) do
    station_id = Map.get(session, "nitrate_station", "IQQ")
    NitrateScope.for_clerk("Valentina", station_id)
  end

  defp scope_from_session(_), do: nil
end
