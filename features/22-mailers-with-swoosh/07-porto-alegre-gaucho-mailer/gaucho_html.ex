# Mailers with Swoosh · 07 · Porto Alegre gaúcho mailer
#
# Teaches:
# - An HTML email layout as a function component with a named inner slot
# - Slot attributes carrying the station masthead into the layout

defmodule PhoenixMultivitaminWeb.PortoAlegreGauchoHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  attr :station, :string, required: true
  attr :craft, :string, required: true
  slot :inner_block, required: true

  def mail_layout(assigns) do
    ~H"""
    <div id="gaucho-mail-layout" style="font-family: Georgia, serif; color: #1c1917;">
      <header id="gaucho-mail-header">
        <strong>{@station}</strong>
        <span> · {@craft}</span>
      </header>
      <main id="gaucho-mail-body">
        {render_slot(@inner_block)}
      </main>
      <footer id="gaucho-mail-footer">Salgado Filho gaúcho desk</footer>
    </div>
    """
  end

  def wind_notice(assigns) do
    ~H"""
    <.mail_layout station={@station} craft={@craft}>
      <p id="wind-copy">
        {@clerk}, the pampeiro is {@pampeiro} kt on the southern apron.
        Hold the {@craft} until the gusts fall through {@threshold} kt.
      </p>
    </.mail_layout>
    """
  end

  def render_to_string(function_component, assigns) do
    function_component.(assigns)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
