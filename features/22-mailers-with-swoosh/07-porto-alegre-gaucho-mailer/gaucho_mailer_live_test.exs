defmodule PhoenixMultivitaminWeb.PortoAlegreGauchoMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.PortoAlegreGauchoMailer

  @path "/features/22-mailers-with-swoosh/07-porto-alegre-gaucho-mailer"

  test "the HTML body includes the mail layout header, body, and footer" do
    assert {:ok, email} =
             PortoAlegreGauchoMailer.deliver_pampeiro_hold("Lorena", "Boeing 737-800", 38, 25)

    assert email.html_body =~ ~s(id="gaucho-mail-header")
    assert email.html_body =~ ~s(id="gaucho-mail-body")
    assert email.html_body =~ ~s(id="gaucho-mail-footer")
    assert email.html_body =~ "pampeiro is 38 kt"
    assert email.text_body =~ "Hold Boeing 737-800 until 25 kt"
  end

  test "sending from the board marks the layout present", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#send-pampeiro-hold") |> render_click()

    assert has_element?(view, "#last-subject", "Pampeiro hold for Boeing 737-800")
    assert has_element?(view, "#layout-present", "true")
    assert_email_sent(subject: "Pampeiro hold for Boeing 737-800")
  end
end
