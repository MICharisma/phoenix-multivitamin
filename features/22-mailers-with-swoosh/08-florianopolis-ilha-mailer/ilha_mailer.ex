# Mailers with Swoosh · 08 · Florianópolis ilha mailer
#
# Teaches:
# - Swoosh.Email.assign/3 accumulating template assigns on the email struct
# - Rendering HEEx from email.assigns after the pipe

defmodule PhoenixMultivitaminWeb.FlorianopolisIlhaMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias PhoenixMultivitaminWeb.FlorianopolisIlhaHTML

  @legs [
    %{channel: "norte", depart: "Hercílio Luz", arrive: "São José"},
    %{channel: "sul", depart: "Campeche", arrive: "Palhoça"}
  ]

  def deliver_ferry_roster(clerk, craft, gate) do
    email =
      new()
      |> to({clerk, "#{String.downcase(clerk)}@sbfl.gov.br"})
      |> from({"Florianópolis ilha desk", "ilha@sbfl.gov.br"})
      |> subject("Ilha ferry roster for #{clerk}")
      |> assign(:clerk, clerk)
      |> assign(:craft, craft)
      |> assign(:gate, gate)
      |> assign(:island, "Florianópolis")
      |> assign(:legs, @legs)
      |> then(&put_bodies/1)

    {:ok, _} = Mailer.deliver(email)
    {:ok, email}
  end

  defp put_bodies(%Swoosh.Email{} = email) do
    html = FlorianopolisIlhaHTML.render_roster(email.assigns)

    text =
      email.assigns.legs
      |> Enum.map_join("\n", fn leg ->
        "#{leg.channel}: #{leg.depart} → #{leg.arrive}"
      end)

    email
    |> html_body(html)
    |> text_body("#{email.assigns.clerk} at #{email.assigns.gate}\n#{text}")
  end
end
