defmodule PhoenixMultivitaminWeb.LalibelaRockMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.LalibelaRockMailer
  alias Swoosh.Adapters.Local.Storage.Memory
  alias Swoosh.Attachment

  @path "/features/22-mailers-with-swoosh/13-lalibela-rock-mailer"

  setup do
    Memory.delete_all()
    :ok
  end

  test "mailer adapter follows the test environment config" do
    assert LalibelaRockMailer.mailer_adapter() == Swoosh.Adapters.Test
  end

  test "capstone email carries dual bodies, inline crest, and itinerary" do
    assert {:ok, email, _meta} =
             LalibelaRockMailer.deliver_via_test("Kidist", "DHC-6 Twin Otter", "Bete Giyorgis")

    assert email.html_body =~ "cid:lalibela-crest.png"
    assert email.text_body =~ "Bete Giyorgis"
    assert email.headers["X-Rock-Church"] == "Bete Giyorgis"

    types = Enum.map(email.attachments, & &1.type)
    assert :inline in types
    assert :attachment in types

    assert Enum.any?(email.attachments, fn
             %Attachment{type: :inline, cid: "lalibela-crest.png"} -> true
             _ -> false
           end)

    assert_email_sent(subject: "Lalibela pilgrimage · Bete Giyorgis")
  end

  test "local preview stores the email without posting to the Test mailbox" do
    assert {:ok, email, stored, message_id} =
             LalibelaRockMailer.deliver_via_local_preview(
               "Kidist",
               "DHC-6 Twin Otter",
               "Bete Giyorgis"
             )

    assert is_binary(message_id)
    assert stored.subject == email.subject
    assert length(Memory.all()) == 1
    refute_email_sent()
  end

  test "the board can send via Test and preview via Local", %{conn: conn} do
    {:ok, view, html} = live(conn, @path)

    assert html =~ "Swoosh.Adapters.Test"
    assert has_element?(view, "#preview-path", "/dev/mailbox")

    view |> element("#send-test-brief") |> render_click()
    assert has_element?(view, "#inline-count", "1")
    assert has_element?(view, "#regular-count", "1")
    assert has_element?(view, "#html-has-cid", "true")
    assert_email_sent(subject: "Lalibela pilgrimage · Bete Giyorgis")

    view |> element("#preview-local-brief") |> render_click()
    refute has_element?(view, "#local-message-id", "none")
  end
end
