defmodule PhoenixMultivitaminWeb.CuritibaWireMailerLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  alias PhoenixMultivitaminWeb.CuritibaWireMailer
  alias Swoosh.Attachment

  @path "/features/22-mailers-with-swoosh/06-curitiba-wire-mailer"

  test "cook cards arrive as regular attachments with CSV content types" do
    assert {:ok, email} = CuritibaWireMailer.deliver_cook_cards("Otávio")

    summary = CuritibaWireMailer.attachment_summary(email)
    assert length(summary) == 2
    assert Enum.all?(summary, &(&1.type == :attachment))

    # Swoosh prepends each attachment, so the last pipe step lands first.
    assert Enum.map(summary, & &1.filename) == ["nose-gear.csv", "aft-spar.csv"]

    assert_email_sent(fn sent ->
      assert Enum.all?(sent.attachments, fn
               %Attachment{type: :attachment, content_type: "text/csv"} -> true
               _ -> false
             end)
    end)
  end

  test "filing from the board lists attachment names", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)

    view |> element("#file-cook-cards") |> render_click()

    assert has_element?(view, "#filed", "true")
    assert has_element?(view, "#attachment-aft-spar", "aft-spar.csv")
    assert has_element?(view, "#attachment-nose-gear", "nose-gear.csv")
  end
end
