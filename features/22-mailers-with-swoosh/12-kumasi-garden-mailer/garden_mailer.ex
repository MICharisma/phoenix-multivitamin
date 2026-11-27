# Mailers with Swoosh · 12 · Kumasi garden mailer
#
# Teaches:
# - from/2 as a station identity, not noreply@
# - Mailer.deliver_many/1 for a crew roster in one adapter call
# - Enum.map building the list, then a single deliver_many

defmodule PhoenixMultivitaminWeb.KumasiGardenMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer

  @station_from {"Kumasi garden tower", "tower@dgsi.gov.gh"}

  @crew [
    {"Ama", "ama@dgsi.gov.gh", "captain"},
    {"Kojo", "kojo@dgsi.gov.gh", "first_officer"},
    {"Efua", "efua@dgsi.gov.gh", "cabin"}
  ]

  def station_from, do: @station_from

  def build_crew_notices(craft, gate) do
    Enum.map(@crew, fn {name, address, role} ->
      new()
      |> to({name, address})
      |> cc({"Garden ops", "ops@dgsi.gov.gh"})
      |> from(@station_from)
      |> reply_to(@station_from)
      |> subject("Garden push for #{name} · #{role}")
      |> text_body("#{name} (#{role}) pushes the #{craft} from #{gate} at Kumasi.")
      |> header("X-Crew-Role", role)
    end)
  end

  def deliver_crew_roster(craft, gate) do
    emails = build_crew_notices(craft, gate)

    case Mailer.deliver_many(emails) do
      {:ok, meta} -> {:ok, emails, meta}
      {:error, reason} -> {:error, reason, emails}
    end
  end
end
