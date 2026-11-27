defmodule PhoenixMultivitaminWeb.GuayaquilGuayasMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.GuayaquilGuayasMailer

  @path "/features/22-mailers-with-swoosh/02-guayaquil-guayas-mailer"

  test "compose_tide_notice fills html, text, cc, bcc, and reply_to" do
    assert {:ok, email} = GuayaquilGuayasMailer.compose_tide_notice("Marisol", tide: "flood")

    assert email.to == [{"Marisol", "marisol@segu.gov.ec"}]
    assert email.cc == [{"Guayas river desk", "river@segu.gov.ec"}]
    assert length(email.bcc) == 2
    assert email.reply_to == {"Duty hydrologist", "hydro@segu.gov.ec"}
    assert email.text_body =~ "flood window"
    assert email.html_body =~ "<strong>flood</strong>"
  end

  test "unknown officers are rejected before an email is built" do
    assert {:error, :unknown_officer} = GuayaquilGuayasMailer.compose_tide_notice("Nerea")
  end

  test "the board shows cc and reply-to after a good compose", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#compose-marisol") |> render_click()

    assert has_element?(view, "#compose-status", "ready")
    assert has_element?(view, "#last-subject", "Guayas ebb notice for Marisol")
    assert has_element?(view, "#last-cc", "Guayas river desk")
    assert has_element?(view, "#last-bcc-count", "2")
    assert has_element?(view, "#last-reply-to", "Duty hydrologist")
    assert has_element?(view, "#html-preview", "ebb")
  end

  test "the stranger button flashes and leaves status rejected", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    html = view |> element("#compose-stranger") |> render_click()

    assert html =~ "No Guayas officer named Nerea"
    assert has_element?(view, "#compose-status", "rejected")
  end
end
