# Mailers with Swoosh · 13 · Lalibela rock mailer
#
# Teaches:
# - Capstone HEEx body referencing an inline cid image

defmodule PhoenixMultivitaminWeb.LalibelaRockHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def pilgrimage_notice(assigns) do
    ~H"""
    <article id="lalibela-mail">
      <h1 id="lalibela-title">{@church} pilgrimage brief</h1>
      <p id="lalibela-copy">
        {@guide} leads the {@craft} party to {@church}. Crest below.
      </p>
      <img id="lalibela-crest" src={"cid:" <> @crest_cid} alt="Lalibela crest" />
      <p id="lalibela-board">
        Board: <a href={@board_url}>{@board_url}</a>
      </p>
    </article>
    """
  end

  def render_notice(assigns) do
    pilgrimage_notice(assigns)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end
end
