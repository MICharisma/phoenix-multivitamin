# Auth and scopes · 09 · Valdivia Los Ríos scope
#
# Teaches:
# - Magic-link / token flow — token becomes a Scope, not :current_user
# - Session key "los_rios_token" redeemed on mount
# - Base.encode64 / decode via LosRiosTokens; with for redeem steps

defmodule PhoenixMultivitaminWeb.ValdiviaLosRiosScopeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.LosRiosScope
  alias PhoenixMultivitaminWeb.LosRiosTokens

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_scenario("Valdivia Los Ríos scope", "Pascual", "DHC-2 Beaver")
      |> assign(:minted_token, nil)
      |> redeem_session_token(session)

    {:ok, socket}
  end

  @impl true
  def handle_event("mint_fog_link", _params, socket) do
    token = LosRiosTokens.mint_login_token("Pascual")
    {:noreply, assign(socket, :minted_token, token)}
  end

  def handle_event("redeem_fog_link", %{"token" => token}, socket) do
    socket =
      case LosRiosTokens.redeem_login_token(token) do
        {:ok, %LosRiosScope{} = scope} ->
          socket
          |> assign(:current_scope, scope)
          |> assign(:redeem_status, :ok)

        {:error, :invalid_token} ->
          socket
          |> assign(:current_scope, nil)
          |> assign(:redeem_status, :invalid)
          |> put_flash(:error, "Fog link expired or forged")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Auth and scopes · 09 · Valdivia Los Ríos scope
      </p>

      <h1>Valdivia Los Ríos scope</h1>
      <p class="lede">
        Clerk {@clerk} redeems a magic fog link at Valdivia (ZAL). The token
        becomes a <code>:current_scope</code>, never a <code>:current_user</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div id="fog-actions">
        <button id="mint-fog-link" type="button" phx-click="mint_fog_link">
          Mint Pascual's fog link
        </button>

        <form id="redeem-fog-form" phx-submit="redeem_fog_link">
          <input
            id="fog-token-input"
            type="text"
            name="token"
            value={@minted_token || ""}
            placeholder="Paste fog link token"
          />
          <button id="redeem-fog-link" type="submit">Redeem fog link</button>
        </form>
      </div>

      <p id="redeem-status">{redeem_label(@redeem_status)}</p>

      <%= if @current_scope do %>
        <dl id="estuary-board" class="station-meta">
          <dt>Clerk</dt>
          <dd id="scope-clerk">{@current_scope.clerk}</dd>
          <dt>Station</dt>
          <dd id="scope-station">{@current_scope.station}</dd>
          <dt>Assigns</dt>
          <dd id="assign-keys">{assign_keys_label(assigns)}</dd>
        </dl>
      <% else %>
        <p id="fog-locked" class="muted">
          Estuary fog desk locked. Mint and redeem a Los Ríos token.
        </p>
      <% end %>
    </Layouts.app>
    """
  end

  defp redeem_session_token(socket, session) do
    case LosRiosTokens.redeem_login_token(session["los_rios_token"]) do
      {:ok, scope} ->
        socket
        |> assign(:current_scope, scope)
        |> assign(:redeem_status, :session)

      {:error, _} ->
        socket
        |> assign(:current_scope, nil)
        |> assign(:redeem_status, :idle)
    end
  end

  defp redeem_label(:session), do: "session"
  defp redeem_label(:ok), do: "redeemed"
  defp redeem_label(:invalid), do: "invalid"
  defp redeem_label(:idle), do: "idle"

  defp assign_keys_label(assigns) do
    keys =
      assigns
      |> Map.keys()
      |> Enum.map(&to_string/1)
      |> Enum.sort()
      |> Enum.join(",")

    keys
  end
end
