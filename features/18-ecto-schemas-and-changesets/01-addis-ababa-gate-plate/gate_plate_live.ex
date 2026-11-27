# Ecto schemas and changesets · 01 · Addis Ababa gate plate
#
# Teaches:
# - An embedded_schema drives a LiveView form without a migration

defmodule PhoenixMultivitaminWeb.AddisGatePlateLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.AddisGatePlate

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      AddisGatePlate.changeset(%AddisGatePlate{}, %{
        "clerk" => "Tigist",
        "craft" => "Boeing 787-8",
        "gate" => "B7",
        "souls" => "214"
      })

    {:ok,
     socket
     |> assign_scenario("Addis Ababa gate plate", "Tigist", "Boeing 787-8")
     |> assign(:form, to_form(changeset, as: :gate_plate))
     |> assign(:posted_gate, nil)}
  end

  @impl true
  def handle_event("validate_plate", %{"gate_plate" => params}, socket) do
    changeset =
      %AddisGatePlate{}
      |> AddisGatePlate.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :gate_plate))}
  end

  def handle_event("post_plate", %{"gate_plate" => params}, socket) do
    changeset =
      %AddisGatePlate{}
      |> AddisGatePlate.changeset(params)
      |> Map.put(:action, :insert)

    socket =
      case apply_action(changeset, :insert) do
        {:ok, plate} ->
          socket
          |> assign(:posted_gate, plate.gate)
          |> assign(:form, to_form(changeset, as: :gate_plate))

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :gate_plate))
      end

    {:noreply, socket}
  end

  defp apply_action(changeset, action) do
    Ecto.Changeset.apply_action(changeset, action)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 01 · Addis Ababa gate plate
      </p>

      <h1>Addis Ababa gate plate</h1>
      <p class="lede">
        Clerk {@clerk} posts an Ethiopian Airlines {@craft} gate plate at Bole
        from an embedded schema with no table.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@posted_gate} id="posted-gate">{@posted_gate}</p>

      <.form for={@form} id="gate-plate-form" phx-change="validate_plate" phx-submit="post_plate">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:gate]} label="Gate" />
        <.input field={@form[:souls]} type="number" label="Souls" />
        <.button id="post-plate" type="submit">Post the plate</.button>
      </.form>
    </Layouts.app>
    """
  end
end
