defmodule PhoenixMultivitaminWeb.DohaHamadCapstoneTest do
  use PhoenixMultivitaminWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PhoenixMultivitaminWeb.DohaGettext
  alias PhoenixMultivitaminWeb.DohaLoadSheet

  @map "/features/24-gettext-translations/13-doha-hamad-capstone"
  @desk "/features/24-gettext-translations/13-doha-hamad-capstone/desk"

  test "params locale beats session and paints Arabic plurals", %{conn: conn} do
    Gettext.put_locale(DohaGettext, "ar")
    msgid = "1 bag on the belt"
    plural = "%{count} bags on the belt"

    assert Gettext.ngettext(DohaGettext, msgid, plural, 0) == "لا حقائب على الحزام"
    assert Gettext.ngettext(DohaGettext, msgid, plural, 1) == "حقيبة واحدة على الحزام"
    assert Gettext.ngettext(DohaGettext, msgid, plural, 2) == "حقيبتان على الحزام"
    assert Gettext.ngettext(DohaGettext, msgid, plural, 3) == "3 حقائب على الحزام"
    assert Gettext.ngettext(DohaGettext, msgid, plural, 11) == "11 حقيبة على الحزام"
    assert Gettext.ngettext(DohaGettext, msgid, plural, 100) == "100 حقيبة على الحزام"

    conn =
      conn
      |> init_test_session(%{"locale" => "en"})
      |> get(@desk <> "?locale=ar&bags=3")

    html = html_response(conn, 200)
    assert conn.assigns.locale == "ar"
    assert conn.assigns.locale_source == :params
    assert html =~ "3 حقائب على الحزام"
    assert html =~ "البوابة جاهزة للصعود"
  end

  test "session locale is used when params omit locale", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{"locale" => "ar"})
      |> get(@desk <> "?bags=1")

    assert conn.assigns.locale == "ar"
    assert conn.assigns.locale_source == :session
    assert html_response(conn, 200) =~ "حقيبة واحدة على الحزام"
  end

  test "changeset errors translate through the errors domain", %{conn: conn} do
    Gettext.put_locale(DohaGettext, "ar")

    errors =
      %DohaLoadSheet{}
      |> DohaLoadSheet.changeset(%{})
      |> DohaLoadSheet.translate_errors()

    assert {:flight, "لا يمكن أن يكون فارغًا"} in errors
    assert {:bags, "لا يمكن أن يكون فارغًا"} in errors

    conn = get(conn, @desk <> "?locale=ar")
    html = html_response(conn, 200)
    assert html =~ "لا يمكن أن يكون فارغًا"
  end

  test "the catalog map links onto the desk", %{conn: conn} do
    {:ok, _view, html} = live(conn, @map)
    assert html =~ "Noor"
    assert html =~ "open-desk"
  end
end
