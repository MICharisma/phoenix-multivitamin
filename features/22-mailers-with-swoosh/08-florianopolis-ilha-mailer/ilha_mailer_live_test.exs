defmodule PhoenixMultivitaminWeb.FlorianopolisIlhaMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.FlorianopolisIlhaMailer

  @path "/features/22-mailers-with-swoosh/08-florianopolis-ilha-mailer"

  test "email.assigns drive the HEEx roster body" do
    assert {:ok, email} =
             FlorianopolisIlhaMailer.deliver_ferry_roster("Bianca", "ATR 42-500", "Gate Sul")

    assert email.assigns.clerk == "Bianca"
    assert email.assigns.gate == "Gate Sul"
    assert length(email.assigns.legs) == 2
    assert email.html_body =~ ~s(id="ilha-roster")
    assert email.html_body =~ ~s(id="leg-norte")
    assert email.html_body =~ ~s(id="leg-sul")
    assert email.text_body =~ "norte: Hercílio Luz"
  end

  test "the board lists assign keys and channels", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#send-ferry-roster") |> render_click()

    assert has_element?(view, "#html-has-roster", "true")
    assert has_element?(view, "#channel-norte", "norte")
    assert has_element?(view, "#channel-sul", "sul")
    assert has_element?(view, "#assign-keys", "clerk")
    assert_email_sent(subject: "Ilha ferry roster for Bianca")
  end
end
