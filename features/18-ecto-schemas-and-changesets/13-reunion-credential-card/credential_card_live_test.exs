defmodule PhoenixMultivitaminWeb.ReunionCredentialCardLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.ReunionCredentialCard

  @path "/features/18-ecto-schemas-and-changesets/13-reunion-credential-card"

  test "change stamps the hangar and redact hides the token on inspect", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Léa")

    view
    |> form("#credential-card-form", credential_card: %{access_token: "short"})
    |> render_change()

    assert has_element?(view, "#credential-card-form", "should be at least 8 character")

    view
    |> form("#credential-card-form", credential_card: %{access_token: "run-hangar-88"})
    |> render_submit()

    assert has_element?(view, "#written-hangar", "RUN1")
    assert has_element?(view, "#inspect-redacted", "redacted")

    card = Repo.get_by!(ReunionCredentialCard, hangar_code: "RUN1")
    assert card.access_token == "run-hangar-88"
    refute String.contains?(inspect(card), "run-hangar-88")
  end
end
