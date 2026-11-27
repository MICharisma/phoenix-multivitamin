defmodule PhoenixMultivitaminWeb.PresenceTrackers do
  @moduledoc """
  Starts every presence tracker used by the Presence feature. Each tracker
  needs `Phoenix.PubSub` running first, so the application lists this
  supervisor after the PubSub child.
  """
  use Supervisor

  @trackers [
    PhoenixMultivitaminWeb.Presence,
    PhoenixMultivitaminWeb.SantoriniCalderaPresence,
    PhoenixMultivitaminWeb.RigaDaugavaPresence,
    PhoenixMultivitaminWeb.VisbyGotlandPresence
  ]

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Supervisor.init(@trackers, strategy: :one_for_one)
  end
end
