# Mailers with Swoosh · 11 · Khartoum confluence mailer
#
# Teaches:
# - header/3 custom headers such as X-Flight-Leg on the email
# - url(~p) verified routes inside HTML and text bodies (no conn required)

defmodule PhoenixMultivitaminWeb.KhartoumConfluenceMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias PhoenixMultivitaminWeb.KhartoumConfluenceHTML

  use PhoenixMultivitaminWeb, :verified_routes

  @board_path "/features/22-mailers-with-swoosh/11-khartoum-confluence-mailer"

  def board_path, do: @board_path

  def board_url, do: url(~p"/features/22-mailers-with-swoosh/11-khartoum-confluence-mailer")

  def deliver_leg_notice(controller, craft, leg_id) do
    board_url = board_url()

    html =
      KhartoumConfluenceHTML.render_notice(%{
        controller: controller,
        craft: craft,
        leg_id: leg_id,
        board_url: board_url
      })

    email =
      new()
      |> to({controller, "#{String.downcase(controller)}@hsss.gov.sd"})
      |> from({"Khartoum confluence desk", "confluence@hsss.gov.sd"})
      |> subject("Confluence leg #{leg_id} for #{controller}")
      |> header("X-Flight-Leg", leg_id)
      |> header("X-Confluence-Station", "Khartoum")
      |> html_body(html)
      |> text_body("#{controller}: leg #{leg_id} for #{craft} is posted at #{board_url}")

    {:ok, _} = Mailer.deliver(email)
    {:ok, email}
  end
end
