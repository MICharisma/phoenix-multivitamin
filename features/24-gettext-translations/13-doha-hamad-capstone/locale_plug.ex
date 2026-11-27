defmodule PhoenixMultivitaminWeb.DohaLocalePlug do
  @moduledoc false
  import Plug.Conn

  @backend PhoenixMultivitaminWeb.DohaGettext
  @supported ~w(ar en)

  def init(opts), do: opts

  def call(conn, _opts) do
    {locale, source} =
      case conn.params do
        %{"locale" => locale} when locale in @supported ->
          {locale, :params}

        _ ->
          case get_session(conn, "locale") do
            locale when locale in @supported ->
              {locale, :session}

            _ ->
              header = conn |> get_req_header("accept-language") |> List.first()
              {pick_from_header(header), :accept_language}
          end
      end

    Gettext.put_locale(@backend, locale)

    conn
    |> assign(:locale, locale)
    |> assign(:locale_source, source)
    |> put_session("locale", locale)
  end

  defp pick_from_header(nil), do: "en"

  defp pick_from_header(header) do
    header
    |> String.split(",", trim: true)
    |> Enum.map(fn tag ->
      tag
      |> String.split(";", parts: 2)
      |> hd()
      |> String.trim()
      |> String.downcase()
      |> String.split("-")
      |> hd()
    end)
    |> Enum.find("en", &(&1 in @supported))
  end
end
