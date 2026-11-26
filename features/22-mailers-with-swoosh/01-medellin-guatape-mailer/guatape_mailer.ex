# Mailers with Swoosh · 01 · Medellín Guatapé mailer
#
# Teaches:
# - Swoosh.Email.new/0 piped through to/2, from/2, subject/2, text_body/2
# - Building a deliverable email from a domain brief without HTML yet

defmodule PhoenixMultivitaminWeb.MedellinGuatapeMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitaminWeb.MedellinGuatapeWatchBrief

  @station_from {"José María Córdova watch", "watch@skrg.gov.co"}

  def build_brief_email(%MedellinGuatapeWatchBrief{} = brief, recipient) do
    new()
    |> to(recipient)
    |> from(@station_from)
    |> subject("Guatapé watch brief for #{brief.controller}")
    |> text_body(text_body_for(brief))
  end

  defp text_body_for(%MedellinGuatapeWatchBrief{} = brief) do
    [
      "Medellín José María Córdova · Guatapé approach desk",
      to_string(brief),
      "Report when the ATR clears the ridge."
    ]
    |> Enum.join("\n")
  end
end
