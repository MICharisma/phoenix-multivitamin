defmodule PhoenixMultivitaminWeb.BeloHorizontePampulhaMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.BeloHorizontePampulhaMailer

  @path "/features/22-mailers-with-swoosh/05-belo-horizonte-pampulha-mailer"

  test "release_lagoon_legs mails only the lagoon lane" do
    emails = BeloHorizontePampulhaMailer.release_lagoon_legs()

    assert length(emails) == 1
    assert hd(emails).subject =~ "lagoon release"

    assert_email_sent(fn email ->
      assert email.to == [{"Igor", "igor@sbbh.gov.br"}]
      assert email.subject =~ "Cessna Citation"
    end)
  end

  test "holding the board leaves the Test mailbox empty" do
    assert :held = BeloHorizontePampulhaMailer.hold_all_legs()
    refute_email_sent()
  end

  test "the board release path asserts email sent", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#release-lagoon") |> render_click()

    assert has_element?(view, "#board-state", "released")
    assert has_element?(view, "#released-count", "1")
    assert_email_sent(subject: "Pampulha lagoon release · Cessna Citation")
  end

  test "the hold path never delivers", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#hold-board") |> render_click()

    assert has_element?(view, "#board-state", "held")
    refute_email_sent()
  end
end
