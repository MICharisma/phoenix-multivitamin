# Mailers with Swoosh · 03 · Belém Ver-o-Peso mailer
#
# Teaches:
# - Delivering through the configured application mailer from a LiveView
# - Mapping deliver results into board assigns with a cond

defmodule PhoenixMultivitaminWeb.BelemVerOPesoMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.BelemVerOPesoMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Belém Ver-o-Peso mailer", "Rafaela", "Cessna Caravan")
     |> assign(:station, "Val de Cans · Ver-o-Peso market desk")
     |> assign(:delivery, :idle)
     |> assign(:last_subject, nil)
     |> assign(:adapter_meta, nil)}
  end

  @impl true
  def handle_event("dispatch_slot", %{"craft" => craft}, socket) do
    result = BelemVerOPesoMailer.deliver_market_slot(socket.assigns.clerk, craft)

    socket =
      cond do
        match?({:ok, _email, _meta}, result) ->
          {:ok, email, meta} = result

          socket
          |> assign(:delivery, :sent)
          |> assign(:last_subject, email.subject)
          |> assign(:adapter_meta, inspect(meta))

        match?({:error, :craft_not_market_ready}, result) ->
          socket
          |> assign(:delivery, :held)
          |> put_flash(:error, "#{craft} stays off the Ver-o-Peso lane")

        true ->
          {:error, reason, _email} = result

          socket
          |> assign(:delivery, :failed)
          |> put_flash(:error, "Delivery failed: #{inspect(reason)}")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Mailers with Swoosh · 03 · Belém Ver-o-Peso mailer
      </p>

      <header class="masthead">
        <h1>Belém Ver-o-Peso mailer</h1>
        <p class="lede">
          Rafaela releases the market freighter slot through the application mailer.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Delivery</dt>
        <dd id="delivery">{@delivery}</dd>
        <dt>Subject</dt>
        <dd id="last-subject">{@last_subject || "none"}</dd>
        <dt>Adapter meta</dt>
        <dd id="adapter-meta">{@adapter_meta || "none"}</dd>
      </dl>

      <div class="watch-actions">
        <button
          id="dispatch-caravan"
          type="button"
          phx-click="dispatch_slot"
          phx-value-craft="Cessna Caravan"
        >
          Dispatch Caravan
        </button>
        <button
          id="dispatch-hercules"
          type="button"
          phx-click="dispatch_slot"
          phx-value-craft="C-130 Hercules"
        >
          Dispatch Hercules
        </button>
      </div>
    </Layouts.app>
    """
  end
end
