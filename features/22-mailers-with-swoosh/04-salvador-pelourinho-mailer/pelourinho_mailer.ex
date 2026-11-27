# Mailers with Swoosh · 04 · Salvador Pelourinho mailer
#
# Teaches:
# - Overriding the adapter per deliver/2 call with Swoosh.Adapters.Local
# - Reading Swoosh.Adapters.Local.Storage.Memory after a Local push
# - The /dev/mailbox preview path the Local adapter feeds

defmodule PhoenixMultivitaminWeb.SalvadorPelourinhoMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias Swoosh.Adapters.Local.Storage.Memory

  @mailbox_preview_path "/dev/mailbox"

  def mailbox_preview_path, do: @mailbox_preview_path

  def configured_adapter do
    :phoenix_multivitamin
    |> Application.fetch_env!(PhoenixMultivitamin.Mailer)
    |> Keyword.fetch!(:adapter)
  end

  def deliver_to_local_mailbox(guide, plaza) do
    email =
      new()
      |> to({guide, "#{slug(guide)}@sbsv.gov.br"})
      |> from({"Salvador Pelourinho tower", "tower@sbsv.gov.br"})
      |> subject("Pelourinho plaza brief · #{plaza}")
      |> text_body("#{guide} walks the #{plaza} plaza before the Embraer 190 turns in.")
      |> header("X-Pelourinho-Plaza", plaza)

    {:ok, %{id: message_id}} = Mailer.deliver(email, adapter: Swoosh.Adapters.Local)

    stored =
      Memory.all()
      |> Enum.find(fn stored_email ->
        stored_email.headers["Message-ID"] == message_id or
          stored_email.subject == email.subject
      end)

    {:ok, email, stored, message_id}
  end

  def flush_local_mailbox, do: Memory.delete_all()

  defp slug(name), do: name |> String.downcase() |> String.replace(" ", "-")
end
