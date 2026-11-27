defmodule PhoenixMultivitaminWeb.LuxorNileMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.LuxorNileMailer

  @path "/features/22-mailers-with-swoosh/10-luxor-nile-mailer"

  test "deliver_without_from returns {:error, :from_not_set} and never mails" do
    assert {:error, :from_not_set, email} = LuxorNileMailer.deliver_without_from("Nour")
    assert email.from == nil
    refute_email_sent()
  end

  test "runway-closed subjects fail through the custom adapter" do
    assert {:error, {:runway_closed, to}, email} =
             LuxorNileMailer.deliver_runway_status("Nour", :closed)

    assert to == [{"Nour", "nour@helx.gov.eg"}]
    assert email.subject =~ "runway-closed"
    refute_email_sent()
  end

  test "runway-open subjects succeed through the custom adapter" do
    assert {:ok, email, %{id: "nile-ok"}} = LuxorNileMailer.deliver_runway_status("Nour", :open)
    assert email.subject =~ "runway open"
    # Custom adapter is not the Test adapter, so no {:email, _} arrives.
    refute_email_sent()
  end

  test "the board surfaces from_not_set and runway_closed", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#send-without-from") |> render_click()
    assert has_element?(view, "#result", "failed")
    assert has_element?(view, "#error-reason", "from_not_set")

    view |> element("#send-runway-closed") |> render_click()
    assert has_element?(view, "#error-reason", "runway_closed:")

    view |> element("#send-runway-open") |> render_click()
    assert has_element?(view, "#result", "sent")
    assert has_element?(view, "#error-reason", "none")
  end
end
