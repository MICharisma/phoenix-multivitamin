# Ecto migrations and multis · 02 · Beja Alentejo migration
#
# Teaches:
# - up/0 and down/0 when change/0 cannot express the reverse
# - cond picks the direction label from exported arities

defmodule PhoenixMultivitaminWeb.BejaAlentejoMigrationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.BejaApronSlip
  alias PhoenixMultivitamin.BejaApronSlipsMigration
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:module, _} = Code.ensure_loaded(BejaApronSlipsMigration)

    direction =
      cond do
        function_exported?(BejaApronSlipsMigration, :up, 0) and
            function_exported?(BejaApronSlipsMigration, :down, 0) ->
          "up_and_down"

        function_exported?(BejaApronSlipsMigration, :change, 0) ->
          "change_only"

        true ->
          "missing"
      end

    {:ok,
     socket
     |> assign_scenario("Beja Alentejo migration", "Rui", "Lockheed C-130H")
     |> assign(:direction, direction)
     |> assign(:written_stand, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("post_slip", %{"apron_slip" => params}, socket) do
    chocks? = Map.get(params, "chocks_on") in ["true", "on", true]

    attrs =
      params
      |> Map.put("chocks_on", chocks?)
      |> Map.put_new("clerk", "Rui")
      |> Map.put_new("craft", "Lockheed C-130H")

    socket =
      case %BejaApronSlip{} |> BejaApronSlip.changeset(attrs) |> Repo.insert() do
        {:ok, slip} ->
          socket
          |> assign(:written_stand, slip.stand)
          |> assign(:form, blank_form())

        {:error, changeset} ->
          assign(socket, :form, to_form(changeset, as: :apron_slip))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 02 · Beja Alentejo migration
      </p>

      <h1>Beja Alentejo migration</h1>
      <p class="lede">
        Clerk {@clerk} posts a {@craft} apron slip at Beja Air Base. The
        migration uses explicit <code>up/0</code> and <code>down/0</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="migration-direction">{@direction}</p>
      <p :if={@written_stand} id="written-stand">{@written_stand}</p>

      <.form for={@form} id="apron-slip-form" phx-submit="post_slip">
        <.input field={@form[:stand]} label="Stand" />
        <.input field={@form[:chocks_on]} type="checkbox" label="Chocks on" />
        <.button id="post-slip" type="submit">Post the slip</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    to_form(%{"stand" => "A3", "chocks_on" => "true"}, as: :apron_slip)
  end
end
