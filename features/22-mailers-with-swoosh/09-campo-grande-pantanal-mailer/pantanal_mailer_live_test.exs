defmodule PhoenixMultivitaminWeb.CampoGrandePantanalMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.CampoGrandePantanalMailer

  @path "/features/22-mailers-with-swoosh/09-campo-grande-pantanal-mailer"

  test "deliver_now returns the sync tag and sends the brief" do
    assert {:ok, :sync, email, _meta} =
             CampoGrandePantanalMailer.deliver_now("Davi", "Cessna Caravan", "Baía Grande")

    assert email.subject == "Pantanal brief · Baía Grande"
    assert_email_sent(subject: "Pantanal brief · Baía Grande")
  end

  test "deliver_async returns the async tag and still hits the Test adapter" do
    assert {:ok, :async, email, _meta} =
             CampoGrandePantanalMailer.deliver_async("Davi", "Cessna Caravan", "Baía Grande")

    assert email.text_body =~ "Baía Grande"
    assert_email_sent(to: {"Davi", "davi@sbcg.gov.br"})
  end

  test "the board can take either path", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#deliver-sync") |> render_click()
    assert has_element?(view, "#delivery-mode", "sync")

    view |> element("#deliver-async") |> render_click()
    assert has_element?(view, "#delivery-mode", "async")
    assert has_element?(view, "#last-subject", "Pantanal brief · Baía Grande")
  end
end
