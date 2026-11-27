# Ecto schemas and changesets · 02 · Nairobi bag tags
#
# Teaches:
# - embeds_many cast through inputs_for for a Kenya Airways load

defmodule PhoenixMultivitaminWeb.NairobiBagTagsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.NairobiBagTag
  alias PhoenixMultivitamin.NairobiLoadCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Nairobi bag tags", "Wanjiku", "Boeing 737-800")
     |> assign(:tag_count, 0)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_load", %{"load_card" => params}, socket) do
    {:noreply, assign(socket, :form, form_from(params, :validate))}
  end

  def handle_event("stamp_load", %{"load_card" => params}, socket) do
    changeset = built(params) |> Map.put(:action, :insert)

    socket =
      case Ecto.Changeset.apply_action(changeset, :insert) do
        {:ok, card} ->
          socket
          |> assign(:tag_count, length(card.bag_tags))
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :load_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto schemas and changesets · 02 · Nairobi bag tags
      </p>

      <h1>Nairobi bag tags</h1>
      <p class="lede">
        Clerk {@clerk} stamps bag tags onto a Kenya Airways {@craft} load card
        with embeds_many.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@tag_count > 0} id="tag-count">{@tag_count}</p>

      <.form for={@form} id="load-card-form" phx-change="validate_load" phx-submit="stamp_load">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.inputs_for :let={tag} field={@form[:bag_tags]}>
          <.input field={tag[:tag_code]} label="Tag code" />
          <.input field={tag[:weight_kg]} type="number" label="Weight kilograms" />
        </.inputs_for>
        <.button id="stamp-load" type="submit">Stamp the load</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %NairobiLoadCard{bag_tags: [%NairobiBagTag{}]}
    |> NairobiLoadCard.changeset(%{
      "clerk" => "Wanjiku",
      "craft" => "Boeing 737-800",
      "bag_tags" => %{"0" => %{"tag_code" => "NBO4821", "weight_kg" => "18"}}
    })
    |> to_form(as: :load_card)
  end

  defp form_from(params, action) do
    to_form(built(params) |> Map.put(:action, action), as: :load_card)
  end

  defp built(params) do
    %NairobiLoadCard{bag_tags: [%NairobiBagTag{}]}
    |> NairobiLoadCard.changeset(params)
  end
end
