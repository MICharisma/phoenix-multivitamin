# Mailers with Swoosh · 03 · Belém Ver-o-Peso mailer
#
# Teaches:
# - PhoenixMultivitamin.Mailer.deliver/1 through the application mailer
# - case on {:ok, metadata} versus leaving the email undelivered
# - Guarded heads that only mail market freighters

defmodule PhoenixMultivitaminWeb.BelemVerOPesoMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer

  def deliver_market_slot(clerk, craft) when craft in ["Cessna Caravan", "Embraer Brasilia"] do
    email =
      new()
      |> to({clerk, clerk_email(clerk)})
      |> from({"Val de Cans Ver-o-Peso desk", "market@sbbe.gov.br"})
      |> subject("Ver-o-Peso slot for #{clerk}")
      |> text_body("#{clerk} takes the #{craft} into the Ver-o-Peso cargo lane.")

    case Mailer.deliver(email) do
      {:ok, metadata} -> {:ok, email, metadata}
      {:error, reason} -> {:error, reason, email}
    end
  end

  def deliver_market_slot(_clerk, _craft), do: {:error, :craft_not_market_ready}

  defp clerk_email("Rafaela"), do: "rafaela@sbbe.gov.br"
  defp clerk_email(clerk), do: "#{String.downcase(clerk)}@sbbe.gov.br"
end
