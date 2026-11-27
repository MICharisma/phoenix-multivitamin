defmodule PhoenixMultivitaminWeb.LyonAcceptLanguageHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def show(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/features/24-gettext-translations/05-lyon-accept-language"}>
          Catalog map
        </.link>
        · Gettext translations · 05 · Lyon Accept-Language
      </p>

      <h1>Lyon Accept-Language desk</h1>
      <p class="lede">
        Clerk {@clerk} serves the Air France ATIS line at {@station}. The
        locale plug read Accept-Language and set <code>{@locale}</code>.
      </p>

      <p id="clerk-name">{@clerk}</p>
      <p id="craft-name">{@craft}</p>
      <p id="locale">{@locale}</p>
      <p id="locale-source">{@locale_source}</p>
      <p id="atis-line">{@atis_line}</p>
    </Layouts.catalog>
    """
  end
end
