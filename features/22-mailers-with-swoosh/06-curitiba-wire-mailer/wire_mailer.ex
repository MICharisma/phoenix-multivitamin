# Mailers with Swoosh · 06 · Curitiba wire mailer
#
# Teaches:
# - Regular (non-inline) Swoosh.Attachment.new/2 from {:data, binary}
# - Enum.reduce/3 accumulating cook-card attachments onto one email
# - Pattern-matching %Swoosh.Attachment{} after the pipe

defmodule PhoenixMultivitaminWeb.CuritibaWireMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias Swoosh.Attachment

  @cards [
    {"aft-spar.csv", "station,torque\naft,42\n"},
    {"nose-gear.csv", "station,torque\nnose,38\n"}
  ]

  def deliver_cook_cards(mechanic) do
    base =
      new()
      |> to({mechanic, "mechanic.#{slug(mechanic)}@sbct.gov.br"})
      |> from({"Curitiba wire loft", "wire@sbct.gov.br"})
      |> subject("Cook cards for #{mechanic}")
      |> text_body("#{mechanic}: torque cook cards for the A320 wire loft.")

    email =
      Enum.reduce(@cards, base, fn {filename, body}, email ->
        attachment =
          Attachment.new({:data, body},
            filename: filename,
            content_type: "text/csv",
            type: :attachment
          )

        attachment(email, attachment)
      end)

    {:ok, _} = Mailer.deliver(email)
    {:ok, email}
  end

  def attachment_summary(%Swoosh.Email{attachments: attachments}) do
    for %Attachment{filename: filename, type: type, content_type: content_type} <- attachments do
      %{filename: filename, type: type, content_type: content_type}
    end
  end

  defp slug(name), do: name |> String.downcase() |> String.replace(" ", "-")
end
