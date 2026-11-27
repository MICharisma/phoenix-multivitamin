defmodule PhoenixMultivitaminWeb.LyonAcceptLanguagePlug do
  @moduledoc false
  import Plug.Conn

  @supported ~w(fr en de)
  @backend PhoenixMultivitaminWeb.LyonGettext

  def init(opts), do: opts

  def call(conn, _opts) do
    locale =
      conn
      |> get_req_header("accept-language")
      |> List.first()
      |> parse_accept_language()
      |> pick_supported()

    Gettext.put_locale(@backend, locale)

    conn
    |> assign(:locale, locale)
    |> assign(:locale_source, :accept_language)
  end

  defp parse_accept_language(nil), do: []

  defp parse_accept_language(header) do
    header
    |> String.split(",", trim: true)
    |> Enum.map(&parse_tag/1)
    |> Enum.sort_by(fn {_tag, q} -> q end, :desc)
    |> Enum.map(fn {tag, _q} -> tag end)
  end

  defp parse_tag(tag) do
    case String.split(tag, ";", parts: 2) do
      [language, "q=" <> q] -> {normalize(language), parse_q(q)}
      [language] -> {normalize(language), 1.0}
    end
  end

  defp parse_q(q) do
    case Float.parse(String.trim(q)) do
      {value, _} -> value
      :error -> 0.0
    end
  end

  defp normalize(language) do
    language
    |> String.trim()
    |> String.downcase()
    |> String.replace("_", "-")
    |> String.split("-", parts: 2)
    |> hd()
  end

  defp pick_supported(tags) do
    Enum.find(tags, "en", &(&1 in @supported))
  end
end
