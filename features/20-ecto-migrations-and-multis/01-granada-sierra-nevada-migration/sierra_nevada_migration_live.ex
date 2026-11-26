# Ecto migrations and multis · 01 · Granada Sierra Nevada migration
#
# Teaches:
# - change/0 that is reversible creates the Granada METAR table
# - with/else maps a failed insert to the form without a rescue

defmodule PhoenixMultivitaminWeb.GranadaSierraNevadaMigrationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.GranadaMetarCard
  alias PhoenixMultivitamin.GranadaMetarCardsMigration
  alias PhoenixMultivitamin.Repo

  @default_attrs %{
    "clerk" => "Inés",
    "craft" => "ATR 72-600",
    "visibility_m" => "800",
    "runway" => "09"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Granada Sierra Nevada migration", "Inés", "ATR 72-600")
     |> assign(:migration_change?, migration_exports_change?())
     |> assign(:written_runway, nil)
     |> assign(:form, to_form(@default_attrs, as: :metar_card))}
  end

  @impl true
  def handle_event("file_metar", %{"metar_card" => params}, socket) do
    socket =
      with {:ok, card} <- insert_metar(params) do
        socket
        |> assign(:written_runway, card.runway)
        |> assign(:form, to_form(@default_attrs, as: :metar_card))
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          assign(socket, :form, to_form(changeset, as: :metar_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 01 · Granada Sierra Nevada migration
      </p>

      <h1>Granada Sierra Nevada migration</h1>
      <p class="lede">
        Clerk {@clerk} files a {@craft} METAR card into the table that <code>change/0</code>
        created under the Sierra Nevada approaches.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="migration-change">{@migration_change?}</p>
      <p :if={@written_runway} id="written-runway">{@written_runway}</p>

      <.form for={@form} id="metar-card-form" phx-submit="file_metar">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:visibility_m]} type="number" label="Visibility metres" />
        <.input field={@form[:runway]} label="Runway" />
        <.button id="file-metar" type="submit">File the METAR</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp insert_metar(params) do
    %GranadaMetarCard{}
    |> GranadaMetarCard.changeset(params)
    |> Repo.insert()
  end

  defp migration_exports_change? do
    {:module, _} = Code.ensure_loaded(GranadaMetarCardsMigration)
    function_exported?(GranadaMetarCardsMigration, :change, 0)
  end
end
