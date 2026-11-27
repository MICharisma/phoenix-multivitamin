defmodule PhoenixMultivitaminWeb.TunisOnMountLocale do
  @moduledoc false

  import Phoenix.Component
  import Phoenix.LiveView

  @backend PhoenixMultivitaminWeb.TunisGettext
  @supported ~w(fr ar en)

  def on_mount(:set_locale, _params, session, socket) do
    locale =
      session
      |> Map.get("locale", "fr")
      |> then(fn tag -> if tag in @supported, do: tag, else: "fr" end)

    Gettext.put_locale(@backend, locale)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign(:locale_from_session, Map.get(session, "locale"))
      |> assign(:on_mount_connected?, connected?(socket))

    {:cont, socket}
  end
end
