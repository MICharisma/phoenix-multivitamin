# Testing · 03 · Darwin fuel form
#
# Teaches:
# - form/3 builds a LiveViewTest form from a DOM id
# - render_change/1 and render_submit/1 drive phx-change and phx-submit

defmodule PhoenixMultivitaminWeb.DarwinFuelFormLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.DarwinFuelSlip

  @impl true
  def mount(_params, _session, socket) do
    changeset = DarwinFuelSlip.changeset(%{bay: "north"})

    {:ok,
     socket
     |> assign_scenario("Darwin fuel form", "Jedda", "Cessna Caravan")
     |> assign(:posted, nil)
     |> assign(:form, to_form(changeset, as: :fuel_slip))}
  end

  @impl true
  def handle_event("validate", %{"fuel_slip" => params}, socket) do
    form =
      params
      |> DarwinFuelSlip.changeset()
      |> Map.put(:action, :validate)
      |> to_form(as: :fuel_slip)

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"fuel_slip" => params}, socket) do
    changeset = DarwinFuelSlip.changeset(params)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, slip} ->
        {:noreply,
         socket
         |> assign(:posted, slip)
         |> assign(:form, to_form(DarwinFuelSlip.changeset(%{bay: slip.bay}), as: :fuel_slip))}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, as: :fuel_slip))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 03 · Darwin fuel form
      </p>

      <h1>Darwin fuel form</h1>
      <p class="lede">
        Clerk {@clerk} posts litres for the {@craft}. LiveViewTest drives the
        slip with <code>form/3</code> and <code>render_submit/1</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.form
        for={@form}
        id="fuel-slip-form"
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:litres]} type="number" label="Litres" />
        <.input
          field={@form[:bay]}
          type="select"
          label="Bay"
          options={[{"North", "north"}, {"South", "south"}]}
        />
        <button id="post-fuel" type="submit">Post fuel</button>
      </.form>

      <p :if={@posted} id="posted-slip">
        {@posted.litres} L on the {@posted.bay} bay
      </p>
    </Layouts.app>
    """
  end
end
