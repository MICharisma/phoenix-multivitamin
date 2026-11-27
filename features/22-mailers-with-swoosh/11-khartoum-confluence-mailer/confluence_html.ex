# Mailers with Swoosh · 11 · Khartoum confluence mailer
#
# Teaches:
# - HEEx mail body interpolating a verified url(~p) board link

defmodule PhoenixMultivitaminWeb.KhartoumConfluenceHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def leg_notice(assigns) do
    ~H"""
    <p id="confluence-mail">
      {@controller}, leg {@leg_id} is posted at
      <a id="confluence-mail-link" href={@board_url}>{@board_url}</a>
      for the {@craft} over the Blue and White Nile.
    </p>
    """
  end

  def render_notice(assigns) do
    leg_notice(assigns)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
