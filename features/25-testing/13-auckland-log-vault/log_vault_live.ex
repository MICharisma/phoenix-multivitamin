# Testing · 13 · Auckland log vault
#
# Teaches:
# - The catalog page archives through the behaviour-backed vault

defmodule PhoenixMultivitaminWeb.AucklandLogVaultLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitamin.AucklandLogVault

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Auckland log vault", "Mere", "A320")
     |> assign(:archive_path, nil)
     |> assign(:archive_error, nil)}
  end

  @impl true
  def handle_event("archive_nzaa", _params, socket) do
    directory = Path.join(System.tmp_dir!(), "auckland-waitemata-vault")

    socket =
      case AucklandLogVault.archive("NZAA", directory) do
        {:ok, path} ->
          socket
          |> assign(:archive_path, path)
          |> assign(:archive_error, nil)

        {:error, reason} ->
          socket
          |> assign(:archive_path, nil)
          |> assign(:archive_error, inspect(reason))
      end

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 13 · Auckland log vault
      </p>

      <h1>Auckland log vault</h1>
      <p class="lede">
        Clerk {@clerk} archives Waitematā METARs for the {@craft}. Tests swap the
        METAR client through application config, capture the log, and write under <code>@tag :tmp_dir</code>.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <button id="archive-nzaa" type="button" phx-click="archive_nzaa">Archive NZAA</button>
      <p :if={@archive_path} id="archive-path">{@archive_path}</p>
      <p :if={@archive_error} id="archive-error">{@archive_error}</p>
    </Layouts.app>
    """
  end
end
