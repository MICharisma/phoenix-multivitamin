# Mailers with Swoosh · 08 · Florianópolis ilha mailer
#
# Teaches:
# - HEEx mail templates driven by assigns carried on the email
# - A for comprehension over ferry legs inside the HTML body

defmodule PhoenixMultivitaminWeb.FlorianopolisIlhaHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def ferry_roster(assigns) do
    ~H"""
    <section id="ilha-roster">
      <h1 id="ilha-title">{@island} ferry roster</h1>
      <p id="ilha-clerk">{@clerk} boards the {@craft} at {@gate}.</p>
      <ul id="ilha-legs">
        <li :for={leg <- @legs} id={"leg-#{leg.channel}"}>
          {leg.channel}: {leg.depart} → {leg.arrive}
        </li>
      </ul>
    </section>
    """
  end

  def render_roster(assigns) do
    ferry_roster(assigns)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
