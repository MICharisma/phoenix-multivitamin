defmodule PhoenixMultivitaminWeb.SharjahCreekHailLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitamin.{Repo, SharjahCreekHail, SharjahCreekHails}

  @path "/features/15-pubsub/09-sharjah-creek-hail"

  test "a hail saved from the form reaches every open board", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    {:ok, ramp, _html} = live(build_conn(), @path)

    tower
    |> form("#hail-form",
      sharjah_creek_hail: %{callsign: "a6-shj", reporting_point: "Mamzar", altitude_ft: 1000}
    )
    |> render_submit()

    %SharjahCreekHail{id: id} = Repo.get_by!(SharjahCreekHail, callsign: "A6-SHJ")
    assert has_element?(tower, "#hails-#{id}", "A6-SHJ over Mamzar at 1000 ft")
    assert has_element?(ramp, "#hails-#{id}", "A6-SHJ over Mamzar")
  end

  test "a write through the context alone still updates the board", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    SharjahCreekHails.subscribe()

    {:ok, hail} =
      SharjahCreekHails.log_hail(%{
        "callsign" => "A6-KLG",
        "reporting_point" => "Khalid Lagoon",
        "altitude_ft" => "800"
      })

    assert_receive {SharjahCreekHails, :hail_logged, ^hail}
    assert has_element?(tower, "#hails-#{hail.id}", "A6-KLG over Khalid Lagoon")
  end

  test "a rejected hail is neither saved nor broadcast", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    SharjahCreekHails.subscribe()

    tower
    |> form("#hail-form",
      sharjah_creek_hail: %{callsign: "N123AB", reporting_point: "Al Khan", altitude_ft: 2500}
    )
    |> render_submit()

    assert has_element?(tower, "#hail-form", "UAE registration")
    assert has_element?(tower, "#hail-form", "less than or equal to 1500")
    assert Repo.aggregate(SharjahCreekHail, :count) == 0
    refute_received {SharjahCreekHails, :hail_logged, _hail}
    assert has_element?(tower, "#creek-hails-empty")
  end

  test "saved hails load on mount before any broadcast", %{conn: conn} do
    {:ok, earlier} =
      SharjahCreekHails.log_hail(%{
        callsign: "A6-MZR",
        reporting_point: "Creek Mouth",
        altitude_ft: 600
      })

    {:ok, tower, _html} = live(conn, @path)
    assert has_element?(tower, "#hails-#{earlier.id}", "A6-MZR over Creek Mouth at 600 ft")
  end
end
