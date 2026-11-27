defmodule PhoenixMultivitaminWeb.BelemVerOPesoMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.BelemVerOPesoMailer

  @path "/features/22-mailers-with-swoosh/03-belem-ver-o-peso-mailer"

  test "deliver_market_slot returns email and metadata through the Test adapter" do
    assert {:ok, email, _meta} =
             BelemVerOPesoMailer.deliver_market_slot("Rafaela", "Cessna Caravan")

    assert email.subject == "Ver-o-Peso slot for Rafaela"
    assert_email_sent(subject: "Ver-o-Peso slot for Rafaela")
  end

  test "non-market craft never reach the adapter" do
    assert {:error, :craft_not_market_ready} =
             BelemVerOPesoMailer.deliver_market_slot("Rafaela", "C-130 Hercules")

    refute_email_sent()
  end

  test "dispatching the Caravan updates the board", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#dispatch-caravan") |> render_click()

    assert has_element?(view, "#delivery", "sent")
    assert has_element?(view, "#last-subject", "Ver-o-Peso slot for Rafaela")
    assert_email_sent(to: {"Rafaela", "rafaela@sbbe.gov.br"})
  end

  test "dispatching the Hercules holds the lane", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("#dispatch-hercules") |> render_click()

    assert html =~ "stays off the Ver-o-Peso lane"
    assert has_element?(view, "#delivery", "held")
  end
end
