defmodule PhoenixMultivitaminWeb.SalvadorPelourinhoMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.SalvadorPelourinhoMailer
  alias Swoosh.Adapters.Local.Storage.Memory

  @path "/features/22-mailers-with-swoosh/04-salvador-pelourinho-mailer"

  setup do
    Memory.delete_all()
    :ok
  end

  test "configured adapter in test is the Test adapter" do
    assert SalvadorPelourinhoMailer.configured_adapter() == Swoosh.Adapters.Test
    assert SalvadorPelourinhoMailer.mailbox_preview_path() == "/dev/mailbox"
  end

  test "deliver_to_local_mailbox stores in Memory and skips the Test mailbox" do
    assert {:ok, email, stored, message_id} =
             SalvadorPelourinhoMailer.deliver_to_local_mailbox("Caetano", "Terreiro de Jesus")

    assert is_binary(message_id)
    assert stored.subject == email.subject
    assert stored.headers["X-Pelourinho-Plaza"] == "Terreiro de Jesus"
    assert Enum.any?(Memory.all(), &(&1.subject == email.subject))

    # Local override never posts {:email, _} to the Test adapter process mailbox.
    refute_email_sent()
  end

  test "posting from the board fills Message-ID and plaza header", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Swoosh.Adapters.Test"
    assert has_element?(view, "#preview-path", "/dev/mailbox")

    view |> element("#post-plaza-brief") |> render_click()

    assert has_element?(view, "#local-subject", "Pelourinho plaza brief · Terreiro de Jesus")
    assert has_element?(view, "#stored-header", "Terreiro de Jesus")
    refute has_element?(view, "#message-id", "none")
  end
end
