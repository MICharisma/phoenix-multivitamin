# Mailers with Swoosh · 08 · Florianópolis ilha mailer
#
# Teaches:
# - Reading email.assigns after compose to show what the template consumed
# - Map.update-style presentation of ferry legs on the board

defmodule PhoenixMultivitaminWeb.FlorianopolisIlhaMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.FlorianopolisIlhaMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Florianópolis ilha mailer", "Bianca", "ATR 42-500")
     |> assign(:station, "Hercílio Luz · ilha desk")
     |> assign(:assign_keys, [])
     |> assign(:leg_channels, [])
     |> assign(:html_has_roster?, false)}
  end

  @impl true
  def handle_event("send_ferry_roster", _params, socket) do
    {:ok, email} =
      FlorianopolisIlhaMailer.deliver_ferry_roster(
        socket.assigns.clerk,
        socket.assigns.craft,
        "Gate Sul"
      )

    channels =
      email.assigns.legs
      |> Enum.map(& &1.channel)
      |> Enum.sort()

    {:noreply,
     socket
     |> assign(:assign_keys, email.assigns |> Map.keys() |> Enum.sort())
     |> assign(:leg_channels, channels)
     |> assign(:html_has_roster?, String.contains?(email.html_body, "ilha-roster"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 08 · Florianópolis ilha mailer
      </p>

      <header class="masthead">
        <h1>Florianópolis ilha mailer</h1>
        <p class="lede">
          Bianca builds ferry-roster assigns on the email, then renders them through HEEx.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Assign keys</dt>
        <dd id="assign-keys">
          {if(@assign_keys == [], do: "none", else: Enum.join(@assign_keys, ", "))}
        </dd>
        <dt>HTML roster</dt>
        <dd id="html-has-roster">{@html_has_roster?}</dd>
      </dl>

      <ul id="leg-channels" class="scenario">
        <li :for={channel <- @leg_channels} id={"channel-#{channel}"}>{channel}</li>
      </ul>

      <div class="watch-actions">
        <button id="send-ferry-roster" type="button" phx-click="send_ferry_roster">
          Send ferry roster
        </button>
      </div>
    </Layouts.app>
    """
  end
end
