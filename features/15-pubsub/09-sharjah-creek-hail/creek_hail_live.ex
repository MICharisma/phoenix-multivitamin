# PubSub · 09 · Sharjah creek hail
#
# Teaches:
# - The context broadcasts after Repo.insert/1 succeeds; the LiveView never broadcasts
# - The context owns the topic: subscribe/0 hides it, and messages are tagged with its module
# - A streamed board is filled by handle_info/2, so writes from anywhere reach every desk

defmodule PhoenixMultivitaminWeb.SharjahCreekHailLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.{SharjahCreekHail, SharjahCreekHails}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: SharjahCreekHails.subscribe()

    {:ok,
     socket
     |> assign_scenario("Sharjah creek hail", "Fatima", "Robinson R44")
     |> assign(reporting_points: SharjahCreekHail.reporting_points())
     |> assign(hail_form: to_form(SharjahCreekHails.change_hail()))
     |> stream(:hails, SharjahCreekHails.recent_hails())}
  end

  @impl true
  def handle_event("validate_hail", %{"sharjah_creek_hail" => hail_params}, socket) do
    changeset = hail_params |> SharjahCreekHails.change_hail() |> Map.put(:action, :validate)
    {:noreply, assign(socket, :hail_form, to_form(changeset))}
  end

  def handle_event("log_hail", %{"sharjah_creek_hail" => hail_params}, socket) do
    case SharjahCreekHails.log_hail(hail_params) do
      {:ok, _hail} ->
        {:noreply, assign(socket, :hail_form, to_form(SharjahCreekHails.change_hail()))}

      {:error, changeset} ->
        {:noreply, assign(socket, :hail_form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({SharjahCreekHails, :hail_logged, %SharjahCreekHail{} = hail}, socket) do
    {:noreply, stream_insert(socket, :hails, hail, at: 0, limit: 10)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 09 · Sharjah creek hail
      </p>
      <header class="masthead">
        <h1>Sharjah creek hail</h1>
        <p class="lede">
          {@clerk} logs helicopter hails over the Sharjah creek reporting points. A hail appears
          on the board only after it is saved, whoever saved it.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <.form
        for={@hail_form}
        id="hail-form"
        phx-change="validate_hail"
        phx-submit="log_hail"
        class="scenario my-6 space-y-4"
      >
        <.input field={@hail_form[:callsign]} type="text" label="Registration" />
        <.input
          field={@hail_form[:reporting_point]}
          type="select"
          label="Reporting point"
          options={@reporting_points}
        />
        <.input field={@hail_form[:altitude_ft]} type="number" label="Altitude (ft)" />
        <button
          id="log-hail"
          type="submit"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800"
        >
          Log hail
        </button>
      </.form>

      <ul id="creek-hails" phx-update="stream" class="watch-log">
        <li id="creek-hails-empty" class="hidden only:block">No hails over the creek yet</li>
        <li :for={{dom_id, hail} <- @streams.hails} id={dom_id}>
          {hail.callsign} over {hail.reporting_point} at {hail.altitude_ft} ft
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
