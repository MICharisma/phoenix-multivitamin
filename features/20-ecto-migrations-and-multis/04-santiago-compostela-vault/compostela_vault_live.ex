# Ecto migrations and multis · 04 · Santiago Compostela vault
#
# Teaches:
# - unique_index errors only after Repo.insert
# - SQLite refuses ALTER TABLE ADD CONSTRAINT for a check

defmodule PhoenixMultivitaminWeb.SantiagoCompostelaVaultLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantiagoSqliteConstraintProbe
  alias PhoenixMultivitamin.SantiagoVaultTicket

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Santiago Compostela vault", "Xoán", "Airbus A320neo")
     |> assign(:written_code, nil)
     |> assign(:block_reason, nil)
     |> assign(:constraint_refusal, nil)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("seal_vault", %{"vault_ticket" => params}, socket) do
    attrs =
      Map.merge(params, %{
        "clerk" => "Xoán",
        "craft" => "Airbus A320neo"
      })

    socket =
      case %SantiagoVaultTicket{} |> SantiagoVaultTicket.changeset(attrs) |> Repo.insert() do
        {:ok, ticket} ->
          socket
          |> assign(:written_code, ticket.vault_code)
          |> assign(:block_reason, nil)
          |> assign(:form, blank_form())

        {:error, changeset} ->
          reason =
            cond do
              Keyword.has_key?(changeset.errors, :vault_code) -> "duplicate_vault"
              Keyword.has_key?(changeset.errors, :litres) -> "litres_not_positive"
              true -> "other"
            end

          socket
          |> assign(:block_reason, reason)
          |> assign(:form, to_form(changeset, as: :vault_ticket))
      end

    {:noreply, socket}
  end

  def handle_event("probe_check_constraint", _params, socket) do
    refusal =
      case SantiagoSqliteConstraintProbe.try_add_check_constraint() do
        :added -> "unexpectedly_added"
        {:refused, message} -> message
      end

    {:noreply, assign(socket, :constraint_refusal, refusal)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto migrations and multis · 04 · Santiago Compostela vault
      </p>

      <h1>Santiago Compostela vault</h1>
      <p class="lede">
        Clerk {@clerk} seals {@craft} fuel vault tickets at Santiago. The
        unique index waits for the write; SQLite refuses a late check constraint.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@written_code} id="written-code">{@written_code}</p>
      <p :if={@block_reason} id="block-reason">{@block_reason}</p>
      <p :if={@constraint_refusal} id="constraint-refusal">{@constraint_refusal}</p>

      <.form for={@form} id="vault-form" phx-submit="seal_vault">
        <.input field={@form[:vault_code]} label="Vault code" />
        <.input field={@form[:litres]} type="number" label="Litres" />
        <.button id="seal-vault" type="submit">Seal the vault</.button>
      </.form>

      <button id="probe-constraint" type="button" phx-click="probe_check_constraint">
        Probe ALTER TABLE ADD CONSTRAINT
      </button>
    </Layouts.app>
    """
  end

  defp blank_form do
    to_form(%{"vault_code" => "SCQ-441", "litres" => "8000"}, as: :vault_ticket)
  end
end
