# Ecto schemas and changesets · 08 · Johannesburg turnaround crew
#
# Teaches:
# - cast_assoc inserts nested crew legs with the turnaround in one write

defmodule PhoenixMultivitaminWeb.JohannesburgTurnaroundCrewLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.JohannesburgTurnaround
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Johannesburg turnaround crew", "Sipho", "Airbus A320")
     |> assign(:crew_names, [])
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_turnaround", %{"turnaround" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("open_turnaround", %{"turnaround" => params}, socket) do
    changeset = built(params)

    socket =
      case Repo.insert(changeset) do
        {:ok, turnaround} ->
          turnaround = Repo.preload(turnaround, :crew_legs)

          socket
          |> assign(:crew_names, Enum.map(turnaround.crew_legs, & &1.name))
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :turnaround))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 08 · Johannesburg turnaround crew
      </p>

      <h1>Johannesburg turnaround crew</h1>
      <p class="lede">
        Clerk {@clerk} opens an SAA {@craft} turnaround at OR Tambo with
        cast_assoc for nested crew legs.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <ul id="crew-list">
        <li :for={name <- @crew_names} id={"crew-#{name}"}>{name}</li>
      </ul>

      <.form
        for={@form}
        id="turnaround-form"
        phx-change="validate_turnaround"
        phx-submit="open_turnaround"
      >
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:stand]} label="Stand" />
        <.inputs_for :let={leg} field={@form[:crew_legs]}>
          <.input field={leg[:role]} label="Role" />
          <.input field={leg[:name]} label="Name" />
        </.inputs_for>
        <.button id="open-turnaround" type="submit">Open the turnaround</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    form_from(
      %{
        "clerk" => "Sipho",
        "craft" => "Airbus A320",
        "stand" => "A12",
        "crew_legs" => %{
          "0" => %{"role" => "captain", "name" => "Lindiwe"}
        }
      },
      nil
    )
  end

  defp form_from(params, action) do
    changeset = built(params)
    changeset = if action, do: Map.put(changeset, :action, action), else: changeset
    to_form(changeset, as: :turnaround)
  end

  defp built(params) do
    %JohannesburgTurnaround{}
    |> JohannesburgTurnaround.changeset(params)
  end
end
