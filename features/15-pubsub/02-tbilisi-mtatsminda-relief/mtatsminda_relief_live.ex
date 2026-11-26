# PubSub · 02 · Tbilisi Mtatsminda relief
#
# Teaches:
# - Phoenix.PubSub.broadcast/3 from handle_event/3 on a desk that never subscribes
# - An enforced-key struct is the message; with/else turns bad relief fields into reasons
# - The broadcast's :ok result, not a handle_info echo, confirms the desk's log

defmodule PhoenixMultivitaminWeb.TbilisiMtatsmindaReliefLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.PubSub
  alias PhoenixMultivitaminWeb.MtatsmindaRelief

  @tower_topic "tbilisi:mtatsminda-reliefs"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Tbilisi Mtatsminda relief", "Nino", "Embraer 190")
     |> assign(sent_reliefs: [], positions: MtatsmindaRelief.positions())
     |> assign_relief_form(%{"position" => "Tower", "incoming" => "", "minutes" => "30"})}
  end

  @impl true
  def handle_event("send_relief", %{"relief" => relief_params}, socket) do
    with {:ok, %MtatsmindaRelief{} = relief} <- MtatsmindaRelief.build(relief_params),
         :ok <- PubSub.broadcast(PhoenixMultivitamin.PubSub, @tower_topic, relief) do
      {:noreply,
       socket
       |> update(:sent_reliefs, &[relief | &1])
       |> assign_relief_form(%{relief_params | "incoming" => ""})}
    else
      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Relief not sent: #{reason |> Atom.to_string() |> String.replace("_", " ")}")
         |> assign_relief_form(relief_params)}
    end
  end

  defp assign_relief_form(socket, params), do: assign(socket, :relief_form, to_form(params, as: :relief))

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 02 · Tbilisi Mtatsminda relief
      </p>
      <header class="masthead">
        <h1>Tbilisi Mtatsminda relief</h1>
        <p class="lede">
          {@clerk} runs the relief rota below Mtatsminda. Her desk only publishes; the tower
          cab listens for each relief.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.form for={@relief_form} id="relief-form" phx-submit="send_relief" class="scenario my-6 space-y-4">
        <.input field={@relief_form[:position]} type="select" label="Position" options={@positions} />
        <.input field={@relief_form[:incoming]} type="text" label="Incoming controller" />
        <.input field={@relief_form[:minutes]} type="number" label="Minutes until relief" />
        <button id="send-relief" type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Send relief to the tower
        </button>
      </.form>

      <ul id="sent-reliefs" class="watch-log">
        <li :for={relief <- @sent_reliefs} id={"relief-#{relief.position}-#{relief.incoming}"}>
          {relief.position}: {relief.incoming} in {relief.minutes} min
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
