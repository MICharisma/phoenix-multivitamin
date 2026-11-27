# Ecto migrations and multis · 03 · Vigo Rías Baixas migration
#
# Teaches:
# - references/2 wires the bay card to a harbour stand
# - A filtered for comprehension lists only heavy cargo bays

defmodule PhoenixMultivitaminWeb.VigoRiasBaixasMigrationLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.VigoBayCard
  alias PhoenixMultivitamin.VigoStand

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Vigo Rías Baixas migration", "Carme", "Dash 8-400")
     |> assign(:heavy_bays, [])
     |> assign(:stand_label, nil)
     |> assign(:form, to_form(%{"label" => "Ría-4", "cargo_kg" => "1200"}, as: :bay))}
  end

  @impl true
  def handle_event("moor_bay", %{"bay" => params}, socket) do
    cargo =
      case Integer.parse(Map.get(params, "cargo_kg", "")) do
        {kg, _} -> kg
        :error -> 0
      end

    result =
      %VigoStand{}
      |> VigoStand.changeset(%{
        label: Map.get(params, "label", "Ría-4"),
        harbour: "Bouzas"
      })
      |> Repo.insert()
      |> then(fn
        {:ok, stand} ->
          %VigoBayCard{}
          |> VigoBayCard.changeset(%{
            clerk: "Carme",
            craft: "Dash 8-400",
            cargo_kg: cargo,
            vigo_stand_id: stand.id
          })
          |> Repo.insert()
          |> then(fn
            {:ok, card} -> {:ok, stand, card}
            {:error, changeset} -> {:error, changeset}
          end)

        {:error, changeset} ->
          {:error, changeset}
      end)

    socket =
      case result do
        {:ok, stand, _card} ->
          heavy =
            for card <- Repo.all(VigoBayCard), card.cargo_kg >= 1000 do
              %{id: card.id, cargo_kg: card.cargo_kg, stand_id: card.vigo_stand_id}
            end

          socket
          |> assign(:stand_label, stand.label)
          |> assign(:heavy_bays, heavy)

        {:error, changeset} ->
          assign(socket, :form, to_form(changeset, as: :bay))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 03 · Vigo Rías Baixas migration
      </p>

      <h1>Vigo Rías Baixas migration</h1>
      <p class="lede">
        Clerk {@clerk} moors a {@craft} bay card against a Bouzas stand.
        The migration's <code>references/2</code> owns the foreign key.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@stand_label} id="stand-label">{@stand_label}</p>

      <.form for={@form} id="bay-form" phx-submit="moor_bay">
        <.input field={@form[:label]} label="Stand label" />
        <.input field={@form[:cargo_kg]} type="number" label="Cargo kilograms" />
        <.button id="moor-bay" type="submit">Moor the bay</.button>
      </.form>

      <ul id="heavy-bays">
        <li :for={bay <- @heavy_bays} id={"heavy-bay-#{bay.id}"}>
          {bay.cargo_kg} kg on stand {bay.stand_id}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
