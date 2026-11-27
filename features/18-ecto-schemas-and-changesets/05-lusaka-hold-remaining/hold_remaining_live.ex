# Ecto schemas and changesets · 05 · Lusaka hold remaining
#
# Teaches:
# - A virtual remaining_min is on the insert struct and gone after Repo.get

defmodule PhoenixMultivitaminWeb.LusakaHoldRemainingLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.LusakaHoldCard
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Lusaka hold remaining", "Chileshe", "Embraer E190")
     |> assign(:inserted_remaining, nil)
     |> assign(:reloaded_remaining, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_hold", %{"hold_card" => params}, socket) do
    changeset =
      %LusakaHoldCard{}
      |> LusakaHoldCard.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :hold_card))}
  end

  def handle_event("write_hold", %{"hold_card" => params}, socket) do
    changeset = LusakaHoldCard.changeset(%LusakaHoldCard{}, params)

    socket =
      case Repo.insert(changeset) do
        {:ok, card} ->
          reloaded = Repo.get!(LusakaHoldCard, card.id)

          socket
          |> assign(:inserted_remaining, card.remaining_min)
          |> assign(:reloaded_remaining, reloaded.remaining_min)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :hold_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 05 · Lusaka hold remaining
      </p>

      <h1>Lusaka hold remaining</h1>
      <p class="lede">
        Clerk {@clerk} computes remaining hold minutes for a Proflight {@craft} as a virtual field that never lands in SQLite.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@inserted_remaining} id="inserted-remaining">{@inserted_remaining}</p>
      <p id="reloaded-remaining">{inspect(@reloaded_remaining)}</p>

      <.form for={@form} id="hold-card-form" phx-change="validate_hold" phx-submit="write_hold">
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:hold_min]} type="number" label="Hold minutes" />
        <.input field={@form[:burned_min]} type="number" label="Burned minutes" />
        <.button id="write-hold" type="submit">Write the hold</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %LusakaHoldCard{}
    |> LusakaHoldCard.changeset(%{
      "clerk" => "Chileshe",
      "craft" => "Embraer E190",
      "hold_min" => "25",
      "burned_min" => "8"
    })
    |> to_form(as: :hold_card)
  end
end
