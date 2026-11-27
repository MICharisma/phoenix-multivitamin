# Ecto schemas and changesets · 11 · Mauritius fuel prepare
#
# Teaches:
# - prepare_changes converts US gallons to litres only on a valid Repo.insert

defmodule PhoenixMultivitaminWeb.MauritiusFuelPrepareLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.MauritiusFuelTicket
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Mauritius fuel prepare", "Priya", "Airbus A330-200")
     |> assign(:written_litres, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_fuel", %{"fuel_ticket" => params}, socket) do
    changeset =
      %MauritiusFuelTicket{}
      |> MauritiusFuelTicket.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :fuel_ticket))}
  end

  def handle_event("uplift_fuel", %{"fuel_ticket" => params}, socket) do
    changeset = MauritiusFuelTicket.changeset(%MauritiusFuelTicket{}, params)

    socket =
      case Repo.insert(changeset) do
        {:ok, ticket} ->
          socket
          |> assign(:written_litres, ticket.litres)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :fuel_ticket))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 11 · Mauritius fuel prepare
      </p>

      <h1>Mauritius fuel prepare</h1>
      <p class="lede">
        Clerk {@clerk} uplifts an Air Mauritius {@craft} at SSR with
        prepare_changes converting US gallons to litres on write.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@written_litres} id="written-litres">{@written_litres}</p>

      <.form for={@form} id="fuel-ticket-form" phx-change="validate_fuel" phx-submit="uplift_fuel">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:litres]} type="number" label="Quantity" />
        <.input
          field={@form[:unit_hint]}
          type="select"
          label="Unit"
          options={[{"Litres", "litre"}, {"US gallons", "us_gallon"}]}
        />
        <.button id="uplift-fuel" type="submit">Uplift the fuel</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %MauritiusFuelTicket{}
    |> MauritiusFuelTicket.changeset(%{
      "clerk" => "Priya",
      "craft" => "Airbus A330-200",
      "litres" => "1000",
      "unit_hint" => "litre"
    })
    |> to_form(as: :fuel_ticket)
  end
end
