# Ecto schemas and changesets · 03 · Dar es Salaam cargo bay
#
# Teaches:
# - embeds_one balances forward and aft kilograms on one card

defmodule PhoenixMultivitaminWeb.DarCargoBayLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.DarCargoBay
  alias PhoenixMultivitamin.DarCargoCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Dar es Salaam cargo bay", "Asha", "ATR 72-600")
     |> assign(:total_kg, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_cargo", %{"cargo_card" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("balance_cargo", %{"cargo_card" => params}, socket) do
    changeset = built(params) |> Map.put(:action, :insert)

    socket =
      case Ecto.Changeset.apply_action(changeset, :insert) do
        {:ok, card} ->
          total = card.bay.forward_kg + card.bay.aft_kg

          socket
          |> assign(:total_kg, total)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :cargo_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 03 · Dar es Salaam cargo bay
      </p>

      <h1>Dar es Salaam cargo bay</h1>
      <p class="lede">
        Clerk {@clerk} balances forward and aft kilograms on a Precision Air {@craft} with embeds_one.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@total_kg} id="total-kg">{@total_kg}</p>

      <.form
        for={@form}
        id="cargo-card-form"
        phx-change="validate_cargo"
        phx-submit="balance_cargo"
      >
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.inputs_for :let={bay} field={@form[:bay]}>
          <.input field={bay[:forward_kg]} type="number" label="Forward kilograms" />
          <.input field={bay[:aft_kg]} type="number" label="Aft kilograms" />
        </.inputs_for>
        <.button id="balance-cargo" type="submit">Balance the bay</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %DarCargoCard{bay: %DarCargoBay{}}
    |> DarCargoCard.changeset(%{
      "clerk" => "Asha",
      "craft" => "ATR 72-600",
      "bay" => %{"forward_kg" => "1200", "aft_kg" => "1100"}
    })
    |> to_form(as: :cargo_card)
  end

  defp form_from(params, action) do
    to_form(built(params) |> Map.put(:action, action), as: :cargo_card)
  end

  defp built(params) do
    %DarCargoCard{bay: %DarCargoBay{}}
    |> DarCargoCard.changeset(params)
  end
end
