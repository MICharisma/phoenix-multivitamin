# Ecto queries and contexts · 08 · Quito altitude tags
#
# Teaches:
# - SQLite-safe lower(?) fragment for matching
# - Concat fragment for a display string

defmodule PhoenixMultivitaminWeb.QuitoAltitudeTagsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.QuitoTagDesk

  @impl true
  def mount(_params, _session, socket) do
    tags = QuitoTagDesk.list_tags_matching("oxygen")

    {:ok,
     socket
     |> assign_scenario("Quito altitude tags", "Lucía", "Boeing 767-300F")
     |> assign(:tags, tags)
     |> assign(:tag_count, length(tags))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Ecto queries and contexts · 08 · Quito altitude tags
      </p>

      <h1>Quito altitude tags</h1>
      <p class="lede">
        Clerk {@clerk} matches {@craft} cargo labels with a SQLite-safe lower
        fragment and builds a display string in SQL.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="tag-count">{@tag_count}</p>

      <ul id="altitude-tags">
        <li :for={tag <- @tags} id={"tag-#{tag.id}"}>
          {tag.display}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
