# Ecto migrations and multis · 09 · Zaragoza Ebro multi
#
# Teaches:
# - Named steps from Enum.reduce build the Multi
# - with unpacks the filed status from the transaction map

defmodule PhoenixMultivitaminWeb.ZaragozaEbroMultiLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.ZaragozaEbroDesk

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Zaragoza Ebro multi", "Pilar", "Airbus A330-200")
     |> assign(:route, nil)
     |> assign(:status, nil)
     |> assign(:step_names, nil)
     |> assign(:form, to_form(%{"route" => "ZAZ-MAD"}, as: :draft))}
  end

  @impl true
  def handle_event("file_route", %{"draft" => params}, socket) do
    socket =
      with {:ok, results} <- ZaragozaEbroDesk.file_route(Map.get(params, "route", "")),
           %{insert_draft: draft, file_draft: filed} <- results do
        socket
        |> assign(:route, draft.route)
        |> assign(:status, filed.status)
        |> assign(:step_names, results |> Map.keys() |> Enum.sort() |> Enum.join(","))
      else
        {:error, _step, _value, _changes} ->
          put_flash(socket, :error, "Could not file the Ebro draft")
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 09 · Zaragoza Ebro multi
      </p>

      <h1>Zaragoza Ebro multi</h1>
      <p class="lede">
        Clerk {@clerk} files a {@craft} draft along the Ebro. Named <code>insert_draft</code>
        and <code>file_draft</code>
        steps land together.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@route} id="filed-route">{@route}</p>
      <p :if={@status} id="filed-status">{@status}</p>
      <p :if={@step_names} id="step-names">{@step_names}</p>

      <.form for={@form} id="draft-form" phx-submit="file_route">
        <.input field={@form[:route]} label="Route" />
        <.button id="file-route" type="submit">File the draft</.button>
      </.form>
    </Layouts.app>
    """
  end
end
