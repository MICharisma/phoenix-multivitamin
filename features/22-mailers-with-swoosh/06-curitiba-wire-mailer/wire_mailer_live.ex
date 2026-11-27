# Mailers with Swoosh · 06 · Curitiba wire mailer
#
# Teaches:
# - Filing cook-card attachments from the board
# - Listing attachment filenames after deliver

defmodule PhoenixMultivitaminWeb.CuritibaWireMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.CuritibaWireMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Curitiba wire mailer", "Otávio", "Airbus A320")
     |> assign(:station, "Afonso Pena · wire loft")
     |> assign(:attachment_names, [])
     |> assign(:filed?, false)}
  end

  @impl true
  def handle_event("file_cook_cards", _params, socket) do
    {:ok, email} = CuritibaWireMailer.deliver_cook_cards(socket.assigns.clerk)
    names = email |> CuritibaWireMailer.attachment_summary() |> Enum.map(& &1.filename)

    {:noreply,
     socket
     |> assign(:attachment_names, names)
     |> assign(:filed?, true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 06 · Curitiba wire mailer
      </p>

      <header class="masthead">
        <h1>Curitiba wire mailer</h1>
        <p class="lede">
          Otávio files A320 torque cook cards as regular CSV attachments from the wire loft.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Filed</dt>
        <dd id="filed">{@filed?}</dd>
      </dl>

      <ul id="attachment-names" class="scenario">
        <li
          :for={name <- @attachment_names}
          id={"attachment-#{Path.rootname(name)}"}
        >
          {name}
        </li>
      </ul>

      <div class="watch-actions">
        <button id="file-cook-cards" type="button" phx-click="file_cook_cards">
          File cook cards
        </button>
      </div>
    </Layouts.app>
    """
  end
end
