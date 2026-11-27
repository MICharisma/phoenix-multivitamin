# Ecto queries and contexts · 06 · Santiago late preload
#
# Teaches:
# - Repo.preload/2 after Repo.all/1
# - Contrast with Tokyo join-preload: two queries, same template shape

defmodule PhoenixMultivitaminWeb.SantiagoLatePreloadLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.SantiagoManifestDesk

  @impl true
  def mount(_params, _session, socket) do
    manifests = SantiagoManifestDesk.list_manifests_with_airline()

    {:ok,
     socket
     |> assign_scenario("Santiago late preload", "Camila", "Airbus A330-200F")
     |> assign(:manifests, manifests)
     |> assign(:manifest_count, length(manifests))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto queries and contexts · 06 · Santiago late preload
      </p>

      <h1>Santiago late preload</h1>
      <p class="lede">
        Clerk {@clerk} fetches {@craft} manifests first, then preloads the
        airline in a second query.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="manifest-count">{@manifest_count}</p>

      <ul id="santiago-manifests">
        <li :for={manifest <- @manifests} id={"manifest-#{manifest.id}"}>
          {manifest.awb} · {manifest.kilograms} kg · {manifest.santiago_airline.name}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
