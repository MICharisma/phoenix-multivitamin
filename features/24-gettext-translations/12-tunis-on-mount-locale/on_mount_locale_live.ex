# Gettext translations · 12 · Tunis on_mount locale
#
# Teaches:
# - LiveView on_mount sets Gettext.put_locale from the session before mount/3
# - on_mount runs in both the disconnected and connected processes
# - Session locale "ar" paints Arabic; missing session keeps French

defmodule PhoenixMultivitaminWeb.TunisOnMountLocaleLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view
  use Gettext, backend: PhoenixMultivitaminWeb.TunisGettext

  on_mount {PhoenixMultivitaminWeb.TunisOnMountLocale, :set_locale}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Tunis on_mount locale", "Amira", "A320")
     |> assign(:page_title, "Tunis on_mount locale")
     |> assign(:station, "Tunis–Carthage")
     |> assign(:airline, "Tunisair")
     |> assign(:brief_line, gettext("Pushback approved from stand 14"))
     |> assign(:mount_saw_locale?, Map.has_key?(socket.assigns, :locale))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Gettext translations · 12 · Tunis on_mount locale
      </p>

      <h1>Tunis on_mount locale</h1>
      <p class="lede">
        Clerk {@clerk} opens the Tunisair pushback brief at {@station}. <code>on_mount</code>
        reads the session locale and calls <code>Gettext.put_locale/2</code>
        before <code>mount/3</code>
        paints
        the line.
      </p>

      <.scenario_identity clerk={@clerk} craft={@craft} />
      <p id="locale">{@locale}</p>
      <p id="mount-saw-locale">{to_string(@mount_saw_locale?)}</p>
      <p id="on-mount-connected">{to_string(@on_mount_connected?)}</p>
      <p id="brief-line">{@brief_line}</p>
    </Layouts.app>
    """
  end
end
