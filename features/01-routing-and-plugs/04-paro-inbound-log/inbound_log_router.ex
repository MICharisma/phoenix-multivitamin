defmodule PhoenixMultivitaminWeb.ParoInboundLogRouter do
  @moduledoc false
  use PhoenixMultivitaminWeb, :router

  # region: inner-pipeline
  # focus: plug PhoenixMultivitaminWeb.ParoInboundPlug
  pipeline :inbound_log do
    plug PhoenixMultivitaminWeb.ParoInboundPlug
  end

  # endregion: inner-pipeline

  # region: inner-routes
  # focus: get "/a319/:reg", ParoInboundLogController, :a319
  scope "/", PhoenixMultivitaminWeb do
    pipe_through :inbound_log

    get "/", ParoInboundLogController, :show
    get "/a319/:reg", ParoInboundLogController, :a319
  end

  # endregion: inner-routes
end
