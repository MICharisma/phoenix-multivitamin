defmodule PhoenixMultivitaminWeb.UshuaiaLookoutRouter do
  @moduledoc false
  use PhoenixMultivitaminWeb, :router

  # region: lookout-pipeline
  # focus: plug PhoenixMultivitaminWeb.UshuaiaLookoutPlug
  pipeline :lookout do
    plug PhoenixMultivitaminWeb.UshuaiaLookoutPlug
  end

  # endregion: lookout-pipeline

  scope "/", PhoenixMultivitaminWeb do
    pipe_through :lookout

    # region: lookout-routes
    # focus: get "/", UshuaiaLookoutController, :desk
    get "/", UshuaiaLookoutController, :desk
    get "/clerks/pilar/watches/icing", UshuaiaLookoutController, :icing
    # endregion: lookout-routes

    # region: nested-resources
    # focus: resources "/watches", UshuaiaWatchController, only: [:index, :show]
    scope "/clerks/:clerk" do
      resources "/watches", UshuaiaWatchController, only: [:index, :show]
    end

    # endregion: nested-resources
  end
end
