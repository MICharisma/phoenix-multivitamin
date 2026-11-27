# Ecto schemas and changesets · 12 · Mahé NOTAM draft
#
# Teaches:
# - A schemaless changeset returns a map from apply_action, not a struct

defmodule PhoenixMultivitaminWeb.MaheNotamDraftLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.MaheNotamDraft

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Mahé NOTAM draft", "Liz", "De Havilland DHC-6")
     |> assign(:draft_icao, nil)
     |> assign(:draft_is_map?, false)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_notam", %{"notam_draft" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("file_notam", %{"notam_draft" => params}, socket) do
    changeset = MaheNotamDraft.changeset(params) |> Map.put(:action, :insert)

    socket =
      case Ecto.Changeset.apply_action(changeset, :insert) do
        {:ok, draft} when is_map(draft) ->
          socket
          |> assign(:draft_icao, draft.icao)
          |> assign(:draft_is_map?, not Map.has_key?(draft, :__struct__))
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :notam_draft))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto schemas and changesets · 12 · Mahé NOTAM draft
      </p>

      <h1>Mahé NOTAM draft</h1>
      <p class="lede">
        Clerk {@clerk} files an Air Seychelles {@craft} NOTAM draft from a
        schemaless changeset with no schema module.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@draft_icao} id="draft-icao">{@draft_icao}</p>
      <p :if={@draft_is_map?} id="draft-is-map">map</p>

      <.form for={@form} id="notam-draft-form" phx-change="validate_notam" phx-submit="file_notam">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:icao]} label="ICAO" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input field={@form[:valid_hours]} type="number" label="Valid hours" />
        <.button id="file-notam" type="submit">File the draft</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    form_from(
      %{
        "clerk" => "Liz",
        "craft" => "De Havilland DHC-6",
        "icao" => "FSIA",
        "body" => "Bird activity near threshold 13",
        "valid_hours" => "6"
      },
      nil
    )
  end

  defp form_from(params, action) do
    changeset = MaheNotamDraft.changeset(params)
    changeset = if action, do: Map.put(changeset, :action, action), else: changeset
    to_form(changeset, as: :notam_draft)
  end
end
