defmodule PhoenixMultivitaminWeb.NairobiBagTagsLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  @path "/features/18-ecto-schemas-and-changesets/02-nairobi-bag-tags"

  test "embeds_many stamps bag tags onto the load card", %{conn: conn} do
    {:ok, view, _html} = live(conn, @path)
    assert has_element?(view, "#clerk-name", "Wanjiku")
    assert has_element?(view, "[name='load_card[bag_tags][0][tag_code]']")

    view
    |> form("#load-card-form", %{
      load_card: %{bag_tags: %{"0" => %{tag_code: "NBO4821", weight_kg: "40"}}}
    })
    |> render_change()

    assert has_element?(view, "#load-card-form", "must be less than or equal to 32")

    view
    |> form("#load-card-form", %{
      load_card: %{bag_tags: %{"0" => %{tag_code: "NBO4821", weight_kg: "18"}}}
    })
    |> render_submit()

    assert has_element?(view, "#tag-count", "1")
  end
end
