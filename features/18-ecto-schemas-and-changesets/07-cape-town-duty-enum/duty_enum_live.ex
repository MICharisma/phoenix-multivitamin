# Ecto schemas and changesets · 07 · Cape Town duty enum
#
# Teaches:
# - Ecto.Enum casts form strings to atoms for duty status

defmodule PhoenixMultivitaminWeb.CapeTownDutyEnumLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.CapeTownDutyCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Cape Town duty enum", "Thandi", "Boeing 737-800")
     |> assign(:duty_status, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_duty", %{"duty_card" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("post_duty", %{"duty_card" => params}, socket) do
    changeset = built(params) |> Map.put(:action, :insert)

    socket =
      case Ecto.Changeset.apply_action(changeset, :insert) do
        {:ok, card} ->
          socket
          |> assign(:duty_status, Atom.to_string(card.status))
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :duty_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 07 · Cape Town duty enum
      </p>

      <h1>Cape Town duty enum</h1>
      <p class="lede">
        Clerk {@clerk} posts a FlySafair {@craft} duty status through Ecto.Enum
        at Cape Town International.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@duty_status} id="duty-status">{@duty_status}</p>

      <.form for={@form} id="duty-card-form" phx-change="validate_duty" phx-submit="post_duty">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={[
            {"Briefing", "briefing"},
            {"Airborne", "airborne"},
            {"Released", "released"}
          ]}
        />
        <.button id="post-duty" type="submit">Post the duty</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    form_from(
      %{
        "clerk" => "Thandi",
        "craft" => "Boeing 737-800",
        "status" => "briefing"
      },
      nil
    )
  end

  defp form_from(params, action) do
    changeset = built(params)
    changeset = if action, do: Map.put(changeset, :action, action), else: changeset
    to_form(changeset, as: :duty_card)
  end

  defp built(params) do
    CapeTownDutyCard.changeset(%CapeTownDutyCard{}, params)
  end
end
