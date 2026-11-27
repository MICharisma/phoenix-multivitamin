# Ecto schemas and changesets · 13 · Réunion credential card
#
# Teaches:
# - Capstone: cast/3 for the form, change/2 for a trusted hangar stamp, redact on inspect

defmodule PhoenixMultivitaminWeb.ReunionCredentialCardLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.ReunionCredentialCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Réunion credential card", "Léa", "ATR 42-500")
     |> assign(:written_hangar, nil)
     |> assign(:inspect_redacted?, false)
     |> assign(:form, blank_form())}
  end

  @impl true
  def handle_event("validate_credential", %{"credential_card" => params}, socket) do
    changeset =
      %ReunionCredentialCard{}
      |> ReunionCredentialCard.changeset(params)
      |> ReunionCredentialCard.stamp_hangar("RUN1")
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: :credential_card))}
  end

  def handle_event("issue_credential", %{"credential_card" => params}, socket) do
    changeset =
      %ReunionCredentialCard{}
      |> ReunionCredentialCard.changeset(params)
      |> ReunionCredentialCard.stamp_hangar("RUN1")

    socket =
      case Repo.insert(changeset) do
        {:ok, card} ->
          printed = inspect(card)
          redacted? = not String.contains?(printed, card.access_token)

          socket
          |> assign(:written_hangar, card.hangar_code)
          |> assign(:inspect_redacted?, redacted?)
          |> assign(:form, blank_form())

        {:error, failed} ->
          assign(socket, :form, to_form(failed, as: :credential_card))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Ecto schemas and changesets · 13 · Réunion credential card
      </p>

      <h1>Réunion credential card</h1>
      <p class="lede">
        Clerk {@clerk} issues a hangar credential for an Air Austral {@craft} at Roland Garros: cast for the form, change for the hangar stamp, redact
        on the access token.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p :if={@written_hangar} id="written-hangar">{@written_hangar}</p>
      <p :if={@inspect_redacted?} id="inspect-redacted">redacted</p>

      <.form
        for={@form}
        id="credential-card-form"
        phx-change="validate_credential"
        phx-submit="issue_credential"
      >
        <.input field={@form[:clerk]} label="Clerk" />
        <.input field={@form[:craft]} label="Craft" />
        <.input field={@form[:access_token]} type="password" label="Access token" />
        <.button id="issue-credential" type="submit">Issue the credential</.button>
      </.form>
    </Layouts.app>
    """
  end

  defp blank_form do
    %ReunionCredentialCard{}
    |> ReunionCredentialCard.changeset(%{
      "clerk" => "Léa",
      "craft" => "ATR 42-500",
      "access_token" => "run-hangar-88"
    })
    |> ReunionCredentialCard.stamp_hangar("RUN1")
    |> to_form(as: :credential_card)
  end
end
