# Gettext translations · 09 · Cairo EgyptAir bindings
#
# Teaches:
# - gettext/2 interpolates %{flight} and %{stand} bindings, never concatenates
# - A capture builds the binding map from the call sheet
# - Missing binding keys leave %{flight} in the msgstr and log an error; they do not raise

defmodule PhoenixMultivitaminWeb.CairoEgyptairBindingsLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.CairoGettext

  @calls [
    %{flight: "MS780", stand: "C4"},
    %{flight: "MS802", stand: "B9"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    Gettext.put_locale(PhoenixMultivitaminWeb.CairoGettext, "ar")

    lines =
      @calls
      |> Enum.map(&paint_call/1)

    {:ok,
     socket
     |> assign_scenario("Cairo EgyptAir bindings", "Nour", "A330-300")
     |> assign(:page_title, "Cairo EgyptAir bindings")
     |> assign(:station, "Cairo International")
     |> assign(:airline, "EgyptAir")
     |> assign(:calls, @calls)
     |> assign(:call_lines, lines)
     |> assign(:active_line, nil)
     |> assign(:binding_error, nil)}
  end

  @impl true
  def handle_event("activate", %{"flight" => flight}, socket) do
    call = Enum.find(@calls, &(&1.flight == flight))

    {:noreply,
     socket
     |> assign(:active_line, paint_call(call))
     |> assign(:binding_error, nil)}
  end

  def handle_event("broken_bindings", _params, socket) do
    # Gettext logs missing bindings and returns the msgstr with %{flight}
    # still in place. It does not raise KeyError.
    {:noreply, assign(socket, :binding_error, gettext("Flight %{flight} to stand %{stand}", %{}))}
  end

  defp paint_call(call) do
    bindings = Map.new([:flight, :stand], &{&1, Map.fetch!(call, &1)})
    gettext("Flight %{flight} to stand %{stand}", bindings)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 09 · Cairo EgyptAir bindings
      </p>

      <h1>Cairo EgyptAir bindings</h1>
      <p class="lede">
        Clerk {@clerk} posts EgyptAir stand assignments at {@station}. The
        Arabic line interpolates named flight and stand bindings — never
        string concatenation.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <ul id="call-board">
        <li :for={line <- @call_lines} id={"call-#{line}"}>
          {line}
        </li>
      </ul>

      <button
        :for={call <- @calls}
        id={"activate-#{call.flight}"}
        type="button"
        phx-click="activate"
        phx-value-flight={call.flight}
      >
        {call.flight}
      </button>

      <button id="broken-bindings" type="button" phx-click="broken_bindings">
        Omit bindings
      </button>

      <p :if={@active_line} id="active-line">{@active_line}</p>
      <p :if={@binding_error} id="binding-error">{@binding_error}</p>
    </Layouts.app>
    """
  end
end
