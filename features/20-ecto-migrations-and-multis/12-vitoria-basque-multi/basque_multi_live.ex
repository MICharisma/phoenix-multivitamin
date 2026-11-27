# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - The LiveView calls only the context; Multi stays private
# - String.Chars renders the enforced result struct

defmodule PhoenixMultivitaminWeb.VitoriaBasqueMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.VitoriaBasqueDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Vitoria Basque multi", "Amaia", "ATR 42-600")
     |> assign(:result_line, nil)
     |> assign(:form, to_form(%{"bay" => "Norte-2", "souls" => "38"}, as: :handover))}
  end

  @impl true
  def handle_event("hand_over", %{"handover" => params}, socket) do
    souls =
      case Integer.parse(Map.get(params, "souls", "")) do
        {value, _} -> value
        :error -> 0
      end

    socket =
      case VitoriaBasqueDesk.hand_over(Map.get(params, "bay", ""), souls) do
        {:ok, result} ->
          assign(socket, :result_line, to_string(result))

        {:error, _step, _value, _changes} ->
          put_flash(socket, :error, "Handover refused")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 12 · Vitoria Basque multi
      </p>

      <h1>Vitoria Basque multi</h1>
      <p class="lede">
        Clerk {@clerk} hands over a {@craft} bay at Vitoria-Gasteiz. The
        context owns the Multi; the LiveView only reads the result struct.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@result_line} id="result-line">{@result_line}</p>

      <.form for={@form} id="handover-form" phx-submit="hand_over">
        <.input field={@form[:bay]} label="Bay" />
        <.input field={@form[:souls]} type="number" label="Souls" />
        <.button id="hand-over" type="submit">Hand over</.button>
      </.form>
    </Layouts.app>
    """
  end
end
