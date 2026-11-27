# Ecto migrations and multis · 07 · Santander Cantabria multi
#
# Teaches:
# - Two Multi.insert/3 steps land together through Repo.transaction/1
# - Map pattern matching unpacks the named results

defmodule PhoenixMultivitaminWeb.SantanderCantabriaMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.SantanderCantabriaDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Santander Cantabria multi", "Itziar", "Boeing 737-800")
     |> assign(:destination, nil)
     |> assign(:litres, nil)
     |> assign(:form, to_form(%{"destination" => "BIO", "litres" => "6200"}, as: :pair))}
  end

  @impl true
  def handle_event("file_pair", %{"pair" => params}, socket) do
    litres =
      case Integer.parse(Map.get(params, "litres", "")) do
        {value, _} -> value
        :error -> 0
      end

    socket =
      case SantanderCantabriaDesk.file_pair(Map.get(params, "destination", ""), litres) do
        {:ok, %{manifest: manifest, fuel_slip: slip}} ->
          socket
          |> assign(:destination, manifest.destination)
          |> assign(:litres, slip.litres)

        {:error, _step, changeset, _changes} ->
          assign(socket, :form, to_form(changeset, as: :pair))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 07 · Santander Cantabria multi
      </p>

      <h1>Santander Cantabria multi</h1>
      <p class="lede">
        Clerk {@clerk} files a {@craft} manifest and fuel slip together at
        Santander. Both inserts share one Multi.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@destination} id="filed-destination">{@destination}</p>
      <p :if={@litres} id="filed-litres">{@litres}</p>

      <.form for={@form} id="pair-form" phx-submit="file_pair">
        <.input field={@form[:destination]} label="Destination" />
        <.input field={@form[:litres]} type="number" label="Litres" />
        <.button id="file-pair" type="submit">File the pair</.button>
      </.form>
    </Layouts.app>
    """
  end
end
