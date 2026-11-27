defmodule PhoenixMultivitaminWeb.CapeTownDutyEnumLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/07-cape-town-duty-enum"

  test "Ecto.Enum casts airborne and rejects an unknown status", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Thandi")

    # LiveViewTest's form helper refuses select values outside options; push the
    # change event directly so Ecto.Enum can reject "diverted".
    render_change(view, "validate_duty", %{
      "duty_card" => %{
        "clerk" => "Thandi",
        "craft" => "Boeing 737-800",
        "status" => "diverted"
      }
    })

    assert has_element?(view, "#duty-card-form", "is invalid")

    view
    |> form("#duty-card-form", duty_card: %{status: "airborne"})
    |> render_submit()

    assert has_element?(view, "#duty-status", "airborne")
  end
end
