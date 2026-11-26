defmodule PhoenixMultivitaminWeb.BeirutCedarsWarningLiveTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.CedarsWarning

  @path "/features/15-pubsub/13-beirut-cedars-warning"
  @topic "beirut:cedars-warnings"

  defp issue(view, hazard, runway) do
    view |> form("#warning-form", hazard: hazard, runway: runway) |> render_submit()
  end

  test "one broadcast reaches the other desk and the issuer gets no echo", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    {:ok, apron, _html} = live(build_conn(), @path <> "?desk=apron")
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    issue(tower, "wind_shear", "16")

    assert_receive {:cedars_warning,
                    %CedarsWarning{id: id, issued_by: "Beirut Tower", runway: "16"}}

    assert has_element?(apron, "#warnings-#{id}", "Wind shear on runway 16 (Beirut Tower)")
    assert has_element?(tower, "#warnings-#{id} .warning-text", "Wind shear on runway 16")
    assert has_element?(tower, "#warnings-#{id} .warning-acks", "acknowledged by Apron Control")
    refute has_element?(tower, "#warnings-#{id} .warning-acks", "Beirut Tower")
  end

  test "each receiving desk acknowledges straight back to the issuer", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    {:ok, apron, _html} = live(build_conn(), @path <> "?desk=apron")
    {:ok, approach, _html} = live(build_conn(), @path <> "?desk=approach")

    issue(tower, "bird_strike", "03")
    [apron, approach] |> Enum.each(&render/1)

    assert has_element?(tower, ".warning-acks", "acknowledged by Apron Control, Beirut Approach")
    refute has_element?(apron, ".warning-acks")
  end

  test "a desk switched by patch issues under its new name", %{conn: conn} do
    {:ok, desk, _html} = live(conn, @path)
    {:ok, tower, _html} = live(build_conn(), @path)

    desk |> element("#desk-approach") |> render_click()
    assert has_element?(desk, "#current-desk", "Beirut Approach")

    issue(desk, "fod", "35")
    assert has_element?(tower, "#cedars-warnings li", "Debris on runway 35 (Beirut Approach)")
    assert has_element?(desk, ".warning-acks", "Beirut Tower")
  end

  test "an unlisted hazard or runway is never broadcast", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)
    Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    render_submit(tower, "issue_warning", %{"hazard" => "volcanic_ash", "runway" => "16"})
    render_submit(tower, "issue_warning", %{"hazard" => "fod", "runway" => "09"})

    assert has_element?(tower, "#flash-error", "Beirut runway")
    assert has_element?(tower, "#cedars-warnings-empty")
    refute_received {:cedars_warning, _warning}
  end

  test "a stray acknowledgement for a warning this desk never issued is ignored", %{conn: conn} do
    {:ok, tower, _html} = live(conn, @path)

    send(tower.pid, {:cedars_ack, 404, "Apron Control"})
    assert has_element?(tower, "#cedars-warnings-empty")
  end
end
