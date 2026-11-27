defmodule PhoenixMultivitaminWeb.DohaHamadCapstoneHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def show(assigns) do
    ~H"""
    <Layouts.catalog flash={@flash}>
      <p class="breadcrumbs">
        <.link navigate={~p"/features/24-gettext-translations/13-doha-hamad-capstone"}>
          Catalog map
        </.link>
        · Gettext translations · 13 · Doha Hamad capstone
      </p>

      <h1>Doha Hamad capstone desk</h1>
      <p class="lede">
        Clerk {@clerk} closes the Qatar Airways load sheet at {@station}.
        Locale came from <code>{@locale_source}</code> as <code>{@locale}</code>.
      </p>

      <p id="clerk-name">{@clerk}</p>
      <p id="craft-name">{@craft}</p>
      <p id="locale">{@locale}</p>
      <p id="locale-source">{@locale_source}</p>
      <p id="bag-line" data-bags={@bags}>{@bag_line}</p>
      <p id="gate-line">{@gate_line}</p>

      <ul id="error-lines">
        <li :for={{field, line} <- @error_lines} id={"error-#{field}"}>
          {field}: {line}
        </li>
      </ul>
    </Layouts.catalog>
    """
  end
end
