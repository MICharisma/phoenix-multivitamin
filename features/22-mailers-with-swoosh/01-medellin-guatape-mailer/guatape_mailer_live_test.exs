defmodule PhoenixMultivitaminWeb.MedellinGuatapeMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.MedellinGuatapeMailer
  alias PhoenixMultivitaminWeb.MedellinGuatapeWatchBrief

  @path "/features/22-mailers-with-swoosh/01-medellin-guatape-mailer"

  test "the brief struct stringifies into the text body" do
    brief = %MedellinGuatapeWatchBrief{
      controller: "Valentina",
      craft: "ATR 72-600",
      runway: "01",
      qnh: 1022
    }

    email = MedellinGuatapeMailer.build_brief_email(brief, {"Valentina", "valentina@skrg.gov.co"})

    assert email.from == {"José María Córdova watch", "watch@skrg.gov.co"}
    assert email.to == [{"Valentina", "valentina@skrg.gov.co"}]
    assert email.subject == "Guatapé watch brief for Valentina"
    assert email.text_body =~ "Valentina holds ATR 72-600 on 01 at QNH 1022"
    assert email.html_body == nil
  end

  test "composing on the board fills the draft fields", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#draft-subject", "none")

    view |> element("#compose-brief") |> render_click()

    assert has_element?(view, "#draft-subject", "Guatapé watch brief for Valentina")
    assert has_element?(view, "#draft-to", "Valentina <valentina@skrg.gov.co>")
    assert has_element?(view, "#draft-text", "ATR 72-600")
  end
end
