# Ecto schemas and changesets · 10 · Antananarivo designator
#
# Teaches:
# - unique_constraint stays silent until the second insert races the index

defmodule PhoenixMultivitaminWeb.AntananarivoDesignatorLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.AntananarivoDesignator
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Antananarivo designator", "Voahangy", "ATR 72-500")
     |> assign(:written_callsign, nil)
     |> assign(:duplicate_blocked?, false)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_designator", %{"designator" => params}, socket) do
    changeset =
      %AntananarivoDesignator{}
      |> AntananarivoDesignator.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :designator))}
  end

  def handle_event("reserve_designator", %{"designator" => params}, socket) do
    changeset = AntananarivoDesignator.changeset(%AntananarivoDesignator{}, params)

    socket =
      case Repo.insert(changeset) do
        {:ok, designator} ->
          socket
          |> assign(:written_callsign, designator.callsign)
          |> assign(:duplicate_blocked?, false)
          |> assign(:form, blank_form())

        {:error, failed} ->
          socket
          |> assign(:duplicate_blocked?, Keyword.has_key?(failed.errors, :callsign))
          |> assign(:form, to_form(failed, as: :designator))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 10 · Antananarivo designator
      </p>

      <h1>Antananarivo designator</h1>
      <p class="lede">
        Clerk {@clerk} reserves a unique Air Madagascar {@craft} callsign at
        Ivato with unique_constraint.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@written_callsign} id="written-callsign">{@written_callsign}</p>
      <p :if={@duplicate_blocked?} id="duplicate-blocked">duplicate blocked</p>

      <.form
        for={@form}
        id="designator-form"
        phx-change="validate_designator"
        phx-submit="reserve_designator"
      >
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:callsign]} label="Callsign" />
        <.button id="reserve-designator" type="submit">Reserve the designator</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %AntananarivoDesignator{}
    |> AntananarivoDesignator.changeset(%{
      "clerk" => "Voahangy",
      "craft" => "ATR 72-500",
      "callsign" => "MDG441"
    })
    |> to_form(as: :designator)
  end
end
