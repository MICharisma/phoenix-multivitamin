# Ecto migrations and multis · 05 · A Coruña Hercules cabinet
#
# Teaches:
# - alter table added lamp_hours with a default so existing rows stay valid
# - SQLite refuses a NOT NULL column without DEFAULT on a non-empty table

defmodule PhoenixMultivitaminWeb.ACorunaHerculesCabinetLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.ACorunaColumnProbe
  alias PhoenixMultivitamin.ACorunaHerculesCabinet
  alias PhoenixMultivitamin.Repo

  @impl true
  def mount(_params, _session, socket) do
    columns = ACorunaColumnProbe.columns("coruna_hercules_cabinets")
    lamp = Enum.find(columns, &(&1.name == "lamp_hours"))

    {:ok,
     socket
     |> assign_scenario("A Coruña Hercules cabinet", "Breogán", "Sikorsky S-92")
     |> assign(:lamp_default, lamp && lamp.dflt_value)
     |> assign(:alter_refusal, nil)
     |> assign(:written_beacon, nil)
     |> assign(
       :form,
       to_form(%{"beacon" => "Tower of Hercules", "lamp_hours" => "12"}, as: :cabinet)
     )}
  end

  @impl true
  def handle_event("log_cabinet", %{"cabinet" => params}, socket) do
    attrs =
      Map.merge(params, %{
        "clerk" => "Breogán",
        "craft" => "Sikorsky S-92"
      })

    socket =
      case %ACorunaHerculesCabinet{}
           |> ACorunaHerculesCabinet.changeset(attrs)
           |> Repo.insert() do
        {:ok, cabinet} ->
          socket
          |> assign(:written_beacon, cabinet.beacon)
          |> assign(
            :form,
            to_form(%{"beacon" => "Tower of Hercules", "lamp_hours" => "12"}, as: :cabinet)
          )

        {:error, changeset} ->
          assign(socket, :form, to_form(changeset, as: :cabinet))
      end

    {:noreply, socket}
  end

  def handle_event("probe_sqlite_limit", _params, socket) do
    refusal =
      case ACorunaColumnProbe.try_add_not_null_without_default(
             "coruna_hercules_cabinets",
             "forbidden_mark"
           ) do
        :added -> "unexpectedly_added"
        {:refused, message} -> message
      end

    {:noreply, assign(socket, :alter_refusal, refusal)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 05 · A Coruña Hercules cabinet
      </p>

      <h1>A Coruña Hercules cabinet</h1>
      <p class="lede">
        Clerk {@clerk} logs {@craft} lamp hours on the Tower of Hercules
        cabinet. The alter that added <code>lamp_hours</code> needed a default.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="lamp-default">{@lamp_default}</p>
      <p :if={@written_beacon} id="written-beacon">{@written_beacon}</p>
      <p :if={@alter_refusal} id="alter-refusal">{@alter_refusal}</p>

      <.form for={@form} id="cabinet-form" phx-submit="log_cabinet">
        <.input field={@form[:beacon]} label="Beacon" />
        <.input field={@form[:lamp_hours]} type="number" label="Lamp hours" />
        <.button id="log-cabinet" type="submit">Log the cabinet</.button>
      </.form>

      <button id="probe-sqlite" type="button" phx-click="probe_sqlite_limit">
        Probe SQLite NOT NULL without DEFAULT
      </button>
    </Layouts.app>
    """
  end
end
