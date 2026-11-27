defmodule PhoenixMultivitaminWeb.KumasiGardenMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.KumasiGardenMailer

  @path "/features/22-mailers-with-swoosh/12-kumasi-garden-mailer"

  test "station from is the garden tower, not noreply" do
    assert KumasiGardenMailer.station_from() ==
             {"Kumasi garden tower", "tower@dgsi.gov.gh"}

    assert {:ok, emails, _meta} =
             KumasiGardenMailer.deliver_crew_roster("Dash 8-400", "Garden Stand 3")

    assert length(emails) == 3
    assert Enum.all?(emails, &(&1.from == {"Kumasi garden tower", "tower@dgsi.gov.gh"}))
    assert Enum.all?(emails, &(&1.reply_to == {"Kumasi garden tower", "tower@dgsi.gov.gh"}))

    assert_emails_sent([
      %{subject: "Garden push for Ama · captain"},
      %{subject: "Garden push for Kojo · first_officer"},
      %{subject: "Garden push for Efua · cabin"}
    ])
  end

  test "deliver_many does not satisfy assert_email_sent for a single {:email, _}" do
    assert {:ok, _emails, _meta} =
             KumasiGardenMailer.deliver_crew_roster("Dash 8-400", "Garden Stand 3")

    # deliver_many posts {:emails, list}, not {:email, one}.
    assert_raise ExUnit.AssertionError, fn ->
      assert_email_sent(subject: "Garden push for Ama · captain")
    end
  end

  test "pushing the roster from the board lists crew roles", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#from-address", "tower@dgsi.gov.gh")
    refute has_element?(view, "#from-address", "noreply")

    view |> element("#push-crew-roster") |> render_click()

    assert has_element?(view, "#roster-count", "3")
    assert has_element?(view, "#role-captain", "captain")
    assert has_element?(view, "#role-first_officer", "first_officer")
    assert has_element?(view, "#role-cabin", "cabin")
  end
end
