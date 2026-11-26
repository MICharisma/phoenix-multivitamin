defmodule PhoenixMultivitaminWeb.KhartoumConfluenceMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.KhartoumConfluenceMailer

  @path "/features/22-mailers-with-swoosh/11-khartoum-confluence-mailer"
  @board_url PhoenixMultivitaminWeb.Endpoint.url() <> @path

  test "headers and verified urls land in both bodies" do
    assert KhartoumConfluenceMailer.board_url() == @board_url

    assert {:ok, email} =
             KhartoumConfluenceMailer.deliver_leg_notice(
               "Samira",
               "Boeing 737-800",
               "KRT-NILE-17"
             )

    assert email.headers["X-Flight-Leg"] == "KRT-NILE-17"
    assert email.headers["X-Confluence-Station"] == "Khartoum"
    assert email.text_body =~ @board_url
    assert email.html_body =~ ~s(href="#{@board_url}")
  end

  test "relaying from the board shows the flight-leg header", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#relay-leg") |> render_click()

    assert has_element?(view, "#flight-leg-header", "KRT-NILE-17")
    assert has_element?(view, "#last-subject", "Confluence leg KRT-NILE-17 for Samira")

    assert_email_sent(fn email ->
      assert email.headers["X-Flight-Leg"] == "KRT-NILE-17"
      assert email.html_body =~ @board_url
    end)
  end
end
