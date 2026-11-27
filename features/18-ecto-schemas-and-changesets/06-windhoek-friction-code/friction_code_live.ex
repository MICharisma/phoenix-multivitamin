# Ecto schemas and changesets · 06 · Windhoek friction code
#
# Teaches:
# - Custom Ecto.Type cast rejects unknown MU codes before the write

defmodule PhoenixMultivitaminWeb.WindhoekFrictionCodeLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.WindhoekFrictionReading

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Windhoek friction code", "Ndapewa", "Airbus A319")
     |> assign(:stored_friction, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_friction", %{"friction_reading" => params}, socket) do
    changeset =
      %WindhoekFrictionReading{}
      |> WindhoekFrictionReading.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :friction_reading))}
  end

  def handle_event("log_friction", %{"friction_reading" => params}, socket) do
    changeset = WindhoekFrictionReading.changeset(%WindhoekFrictionReading{}, params)

    socket =
      case Repo.insert(changeset) do
        {:ok, reading} ->
          socket
          |> assign(:stored_friction, reading.friction)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :friction_reading))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 06 · Windhoek friction code
      </p>

      <h1>Windhoek friction code</h1>
      <p class="lede">
        Clerk {@clerk} logs runway MU codes for an Air Namibia {@craft} through
        a custom Ecto.Type at Hosea Kutako.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@stored_friction} id="stored-friction">{@stored_friction}</p>

      <.form
        for={@form}
        id="friction-form"
        phx-change="validate_friction"
        phx-submit="log_friction"
      >
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:runway]} label="Runway" />
        <.input field={@form[:friction]} label="Friction code" />
        <.button id="log-friction" type="submit">Log the reading</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %WindhoekFrictionReading{}
    |> WindhoekFrictionReading.changeset(%{
      "clerk" => "Ndapewa",
      "runway" => "08",
      "friction" => "GOOD"
    })
    |> to_form(as: :friction_reading)
  end
end
