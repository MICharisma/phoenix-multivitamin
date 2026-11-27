# Ecto migrations and multis · 13 · Logroño Rioja handover
#
# Teaches:
# - Capstone: unique migration index plus a four-step context Multi
# - Duplicate batch_code reports the failed step name from the Multi

defmodule PhoenixMultivitaminWeb.LogronoRiojaHandoverLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.LogronoRiojaDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Logroño Rioja handover", "Laia", "Bombardier CRJ900")
     |> assign(:batch_code, nil)
     |> assign(:status, nil)
     |> assign(:note_body, nil)
     |> assign(:failed_step, nil)
     |> assign(
       :form,
       to_form(%{"batch_code" => "RJ-2201", "note_body" => "sealed at RJL"}, as: :batch)
     )}
  end

  @impl true
  def handle_event("seal_batch", %{"batch" => params}, socket) do
    socket =
      case LogronoRiojaDesk.seal_batch(
             Map.get(params, "batch_code", ""),
             Map.get(params, "note_body", "")
           ) do
        {:ok, %{sealed_batch: batch, note: note}} ->
          socket
          |> assign(:batch_code, batch.batch_code)
          |> assign(:status, batch.status)
          |> assign(:note_body, note.body)
          |> assign(:failed_step, nil)

        {:error, failed_step, _value, _changes} ->
          socket
          |> assign(:batch_code, nil)
          |> assign(:status, nil)
          |> assign(:note_body, nil)
          |> assign(:failed_step, to_string(failed_step))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 13 · Logroño Rioja handover
      </p>

      <h1>Logroño Rioja handover</h1>
      <p class="lede">
        Clerk {@clerk} seals a {@craft} Rioja batch at Logroño. The unique
        index and a four-step Multi (insert, run, update, note) finish the
        feature.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@batch_code} id="sealed-code">{@batch_code}</p>
      <p :if={@status} id="sealed-status">{@status}</p>
      <p :if={@note_body} id="sealed-note">{@note_body}</p>
      <p :if={@failed_step} id="failed-step">{@failed_step}</p>

      <.form for={@form} id="batch-form" phx-submit="seal_batch">
        <.input field={@form[:batch_code]} label="Batch code" />
        <.input field={@form[:note_body]} label="Note" />
        <.button id="seal-batch" type="submit">Seal the batch</.button>
      </.form>
    </Layouts.app>
    """
  end
end
