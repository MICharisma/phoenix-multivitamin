# Gettext translations · 02 · Warsaw LOT apron
#
# Teaches:
# - ngettext/3 picks a plural form from the count
# - Polish has three plural forms; 1, 2–4, and 5+ diverge
# - Enum.map over apron counts builds the board without concatenating English

defmodule PhoenixMultivitaminWeb.WarsawLotApronLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.WarsawGettext

  @apron_counts [1, 2, 5, 22]

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.WarsawGettext, "pl")

    lines =
      for count <- @apron_counts do
        {count, ngettext("1 aircraft on the apron", "%{count} aircraft on the apron", count)}
      end

    {:ok,
     socket
     |> assign_scenario("Warsaw LOT apron", "Basia", "Embraer 195")
     |> assign(:page_title, "Warsaw LOT apron")
     |> assign(:station, "Warsaw Chopin")
     |> assign(:airline, "LOT Polish Airlines")
     |> assign(:apron_lines, lines)
     |> assign(:selected_count, nil)
     |> assign(:selected_line, nil)}
  end

  @impl true
  def handle_event("tally", %{"count" => count_str}, socket) do
    count = String.to_integer(count_str)

    {:noreply,
     socket
     |> assign(:selected_count, count)
     |> assign(
       :selected_line,
       ngettext("1 aircraft on the apron", "%{count} aircraft on the apron", count)
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 02 · Warsaw LOT apron
      </p>

      <h1>Warsaw LOT apron</h1>
      <p class="lede">
        Clerk {@clerk} tallies {@airline} Embraers on the Chopin apron.
        Polish <code>ngettext/3</code> yields three forms: one, few, and many.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ul id="apron-board">
        <li :for={{count, line} <- @apron_lines} id={"apron-#{count}"}>
          <button
            id={"tally-#{count}"}
            type="button"
            phx-click="tally"
            phx-value-count={count}
          >
            {line}
          </button>
        </li>
      </ul>

      <p :if={@selected_line} id="selected-line" data-count={@selected_count}>
        {@selected_line}
      </p>
    </Layouts.app>
    """
  end
end
