# Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi
#
# Teaches:
# - Failed Multi returns failed_operation, failed_value, changes_so_far
# - changes_so_far still holds the order struct; the DB row is gone

defmodule PhoenixMultivitaminWeb.SalamancaPlazaMayorMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.SalamancaPlazaDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Salamanca Plaza Mayor multi", "Jimena", "Cessna Citation CJ4")
     |> assign(:placed_stand, nil)
     |> assign(:failed_operation, nil)
     |> assign(:order_in_changes, nil)
     |> assign(:order_persisted, nil)
     |> assign(
       :form,
       to_form(%{"stand" => "PM-1", "part" => "brake_pad", "qty" => "2"}, as: :order)
     )}
  end

  @impl true
  def handle_event("place_order", %{"order" => params}, socket) do
    qty =
      case Integer.parse(Map.get(params, "qty", "")) do
        {value, _} -> value
        :error -> 0
      end

    socket =
      case SalamancaPlazaDesk.place_order(
             Map.get(params, "stand", ""),
             Map.get(params, "part", ""),
             qty
           ) do
        {:ok, %{order: order}} ->
          socket
          |> assign(:placed_stand, order.stand)
          |> assign(:failed_operation, nil)
          |> assign(:order_in_changes, nil)
          |> assign(:order_persisted, nil)

        {:error, summary} ->
          socket
          |> assign(:placed_stand, nil)
          |> assign(:failed_operation, to_string(summary.failed_operation))
          |> assign(:order_in_changes, match?(%{order: %{id: _}}, summary.changes_so_far))
          |> assign(:order_persisted, summary.order_persisted?)
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 10 · Salamanca Plaza Mayor multi
      </p>

      <h1>Salamanca Plaza Mayor multi</h1>
      <p class="lede">
        Clerk {@clerk} places a {@craft} parts order on the Plaza Mayor apron.
        A bad line short-circuits the Multi and leaves the order out of the DB.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@placed_stand} id="placed-stand">{@placed_stand}</p>
      <p :if={@failed_operation} id="failed-operation">{@failed_operation}</p>
      <p :if={@order_in_changes != nil} id="order-in-changes">{@order_in_changes}</p>
      <p :if={@order_persisted != nil} id="order-persisted">{@order_persisted}</p>

      <.form for={@form} id="order-form" phx-submit="place_order">
        <.input field={@form[:stand]} label="Stand" />
        <.input field={@form[:part]} label="Part" />
        <.input field={@form[:qty]} type="number" label="Quantity" />
        <.button id="place-order" type="submit">Place the order</.button>
      </.form>
    </Layouts.app>
    """
  end
end
