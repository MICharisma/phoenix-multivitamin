# Mailers with Swoosh · 13 · Lalibela rock mailer
#
# Teaches:
# - Capstone: text + html, inline cid crest, regular itinerary attachment
# - Local adapter mailbox preview alongside the Test-env default
# - Environment adapter introspection for config/dev versus config/test

defmodule PhoenixMultivitaminWeb.LalibelaRockMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer
  alias PhoenixMultivitaminWeb.LalibelaRockHTML
  alias Swoosh.Adapters.Local.Storage.Memory
  alias Swoosh.Attachment

  use PhoenixMultivitaminWeb, :verified_routes

  @crest_cid "lalibela-crest.png"
  @crest_png Base.decode64!(
               "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
             )
  @itinerary "church,eta\nBete Giyorgis,09:40\nBete Medhane Alem,11:15\n"

  def crest_cid, do: @crest_cid

  def board_url, do: url(~p"/features/22-mailers-with-swoosh/13-lalibela-rock-mailer")

  def mailer_adapter do
    :phoenix_multivitamin
    |> Application.fetch_env!(PhoenixMultivitamin.Mailer)
    |> Keyword.fetch!(:adapter)
  end

  def build_pilgrimage_email(guide, craft, church) do
    board_url = board_url()

    html =
      LalibelaRockHTML.render_notice(%{
        guide: guide,
        craft: craft,
        church: church,
        crest_cid: @crest_cid,
        board_url: board_url
      })

    new()
    |> to({guide, "#{slug(guide)}@hall.gov.et"})
    |> from({"Lalibela rock desk", "rock@hall.gov.et"})
    |> reply_to({"Lalibela rock desk", "rock@hall.gov.et"})
    |> subject("Lalibela pilgrimage · #{church}")
    |> header("X-Rock-Church", church)
    |> html_body(html)
    |> text_body("#{guide}: #{church} brief for the #{craft}. Board: #{board_url}")
    |> attachment(
      Attachment.new({:data, @crest_png},
        filename: @crest_cid,
        content_type: "image/png",
        type: :inline,
        cid: @crest_cid
      )
    )
    |> attachment(
      Attachment.new({:data, @itinerary},
        filename: "itinerary.csv",
        content_type: "text/csv",
        type: :attachment
      )
    )
  end

  def deliver_via_test(guide, craft, church) do
    email = build_pilgrimage_email(guide, craft, church)
    {:ok, meta} = Mailer.deliver(email)
    {:ok, email, meta}
  end

  def deliver_via_local_preview(guide, craft, church) do
    email = build_pilgrimage_email(guide, craft, church)
    Memory.delete_all()
    {:ok, %{id: message_id}} = Mailer.deliver(email, adapter: Swoosh.Adapters.Local)
    stored = Enum.find(Memory.all(), &(&1.subject == email.subject))
    {:ok, email, stored, message_id}
  end

  defp slug(name), do: name |> String.downcase() |> String.replace(" ", "-")
end
