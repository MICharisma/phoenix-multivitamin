# Gettext translations · 08 · Moscow Sheremetyevo plurals
#
# Teaches:
# - Russian ngettext uses three plural forms (1, 2–4, 5+ / teens)
# - Enum.reduce builds a slot ledger of translated lines
# - Tuple results keep the count beside the msgstr

defmodule PhoenixMultivitaminWeb.MoscowSheremetyevoPluralsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.MoscowGettext

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.MoscowGettext, "ru")

    ledger =
      [1, 2, 5, 21, 22]
      |> Enum.reduce([], fn count, acc ->
        line =
          ngettext("1 free stand", "%{count} free stands", count)

        [{count, line} | acc]
      end)
      |> Enum.reverse()

    {:ok,
     socket
     |> assign_scenario("Moscow Sheremetyevo plurals", "Irina", "SSJ100")
     |> assign(:page_title, "Moscow Sheremetyevo plurals")
     |> assign(:station, "Sheremetyevo")
     |> assign(:airline, "Aeroflot")
     |> assign(:ledger, ledger)
     |> assign(:spotlight, nil)}
  end

  @impl true
  def handle_event("spotlight", %{"count" => count_str}, socket) do
    count = String.to_integer(count_str)
    {^count, line} = Enum.find(socket.assigns.ledger, fn {c, _} -> c == count end)
    {:noreply, assign(socket, :spotlight, {count, line})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Gettext translations · 08 · Moscow Sheremetyevo plurals
      </p>

      <h1>Moscow Sheremetyevo plurals</h1>
      <p class="lede">
        Clerk {@clerk} counts Aeroflot free stands at {@station}. Russian <code>ngettext/3</code>
        needs three forms, including the teen rule
        that sends 21 back to the singular.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ul id="stand-ledger">
        <li :for={{count, line} <- @ledger} id={"stand-#{count}"}>
          <button
            id={"spotlight-#{count}"}
            type="button"
            phx-click="spotlight"
            phx-value-count={count}
          >
            {line}
          </button>
        </li>
      </ul>

      <p :if={@spotlight} id="spotlight-line">{elem(@spotlight, 1)}</p>
    </Layouts.app>
    """
  end
end
