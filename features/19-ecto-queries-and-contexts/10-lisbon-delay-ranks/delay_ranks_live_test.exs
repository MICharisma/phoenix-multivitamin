defmodule PhoenixMultivitaminWeb.LisbonDelayRanksLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.LisbonDelay
  alias PhoenixMultivitamin.Repo

  @path "/features/19-ecto-queries-and-contexts/10-lisbon-delay-ranks"

  test "window ranks delays per airline by minutes descending", %{conn: conn} do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    rows = [
      {"TAP Air Portugal", "Embraer E190", 45},
      {"TAP Air Portugal", "Embraer E190", 12},
      {"easyJet", "Airbus A320", 30},
      {"easyJet", "Airbus A320", 55}
    ]

    for {airline, craft, minutes} <- rows do
      {:ok, _} =
        Repo.insert(%LisbonDelay{
          clerk: "Inês",
          craft: craft,
          airline: airline,
          minutes: minutes,
          inserted_at: now,
          updated_at: now
        })
    end

    {:ok, view, _html} = live(conn, @path)

    assert has_element?(view, "#delay-count", "4")
    html = render(view)

    assert html =~ "#1 · TAP Air Portugal · 45 min"
    assert html =~ "#2 · TAP Air Portugal · 12 min"
    assert html =~ "#1 · easyJet · 55 min"
    assert html =~ "#2 · easyJet · 30 min"
  end
end
