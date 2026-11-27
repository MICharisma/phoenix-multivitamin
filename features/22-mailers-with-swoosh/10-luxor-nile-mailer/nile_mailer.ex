# Mailers with Swoosh · 10 · Luxor Nile mailer
#
# Teaches:
# - Mailer.deliver/1 returning {:error, :from_not_set} when from is missing
# - deliver/2 with a failing adapter yielding {:error, {:runway_closed, to}}
# - with/else mapping both error shapes for the board

defmodule PhoenixMultivitaminWeb.LuxorNileMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias PhoenixMultivitaminWeb.LuxorNileFailingAdapter

  def deliver_without_from(controller) do
    email =
      new()
      |> to({controller, "#{String.downcase(controller)}@helx.gov.eg"})
      |> subject("Nile dawn brief")
      |> text_body("#{controller} waits on the Nile dawn slot.")

    case Mailer.deliver(email) do
      {:ok, meta} -> {:ok, email, meta}
      {:error, reason} -> {:error, reason, email}
    end
  end

  def deliver_runway_status(controller, status) when status in [:open, :closed] do
    subject =
      case status do
        :open -> "Nile runway open for #{controller}"
        :closed -> "Nile runway-closed for #{controller}"
      end

    email =
      new()
      |> to({controller, "#{String.downcase(controller)}@helx.gov.eg"})
      |> from({"Luxor Nile tower", "tower@helx.gov.eg"})
      |> subject(subject)
      |> text_body(nile_copy(controller, status))

    with {:ok, meta} <- Mailer.deliver(email, adapter: LuxorNileFailingAdapter) do
      {:ok, email, meta}
    else
      {:error, reason} -> {:error, reason, email}
    end
  end

  defp nile_copy(controller, :open), do: "#{controller}: runway 02 is open over the Nile bend."
  defp nile_copy(controller, :closed), do: "#{controller}: runway 02 stays closed for dredging."
end
