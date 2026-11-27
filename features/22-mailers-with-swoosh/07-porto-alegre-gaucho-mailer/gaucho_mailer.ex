# Mailers with Swoosh · 07 · Porto Alegre gaúcho mailer
#
# Teaches:
# - Wrapping HEEx mail content in a shared layout before html_body/2
# - Keeping a plain text_body/2 twin for clients that skip HTML

defmodule PhoenixMultivitaminWeb.PortoAlegreGauchoMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias PhoenixMultivitaminWeb.PortoAlegreGauchoHTML

  @station "Salgado Filho · gaúcho desk"

  def deliver_pampeiro_hold(clerk, craft, pampeiro, threshold) do
    html =
      PortoAlegreGauchoHTML.render_to_string(&PortoAlegreGauchoHTML.wind_notice/1, %{
        station: @station,
        clerk: clerk,
        craft: craft,
        pampeiro: pampeiro,
        threshold: threshold
      })

    email =
      new()
      |> to({clerk, "#{String.downcase(clerk)}@sbpa.gov.br"})
      |> from({"Porto Alegre gaúcho desk", "gaucho@sbpa.gov.br"})
      |> subject("Pampeiro hold for #{craft}")
      |> html_body(html)
      |> text_body(
        "#{clerk}: pampeiro #{pampeiro} kt on the southern apron. Hold #{craft} until #{threshold} kt."
      )

    {:ok, _} = Mailer.deliver(email)
    {:ok, email}
  end
end
