# Ecto schemas and changesets · 09 · Maputo callsign validate
#
# Teaches:
# - validate_change/3 refuses a callsign that fails the ICAO shape

defmodule PhoenixMultivitaminWeb.MaputoCallsignValidateLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.MaputoRampCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Maputo callsign validate", "Graça", "Embraer E190")
     |> assign(:accepted_callsign, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_ramp", %{"ramp_card" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("accept_ramp", %{"ramp_card" => params}, socket) do
    changeset = built(params) |> Map.put(:action, :insert)

    socket =
      case Ecto.Changeset.apply_action(changeset, :insert) do
        {:ok, card} ->
          socket
          |> assign(:accepted_callsign, card.callsign)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :ramp_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 09 · Maputo callsign validate
      </p>

      <h1>Maputo callsign validate</h1>
      <p class="lede">
        Clerk {@clerk} checks a LAM Mozambique {@craft} callsign with
        validate_change before the ramp accepts it.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@accepted_callsign} id="accepted-callsign">{@accepted_callsign}</p>

      <.form for={@form} id="ramp-card-form" phx-change="validate_ramp" phx-submit="accept_ramp">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:callsign]} label="Callsign" />
        <.button id="accept-ramp" type="submit">Accept the ramp</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    form_from(
      %{"clerk" => "Graça", "craft" => "Embraer E190", "callsign" => "LAM312"},
      nil
    )
  end

  defp form_from(params, action) do
    changeset = built(params)
    changeset = if action, do: Map.put(changeset, :action, action), else: changeset
    to_form(changeset, as: :ramp_card)
  end

  defp built(params), do: MaputoRampCard.changeset(%MaputoRampCard{}, params)
end
