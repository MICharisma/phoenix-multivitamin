defmodule PhoenixMultivitaminWeb.Presence do
  @moduledoc """
  The feature's plain presence tracker. Scenarios that override `fetch/2` or
  implement `handle_metas/4` define their own tracker in their folder.
  """
  use Phoenix.Presence,
    otp_app: :phoenix_multivitamin,
    pubsub_server: PhoenixMultivitamin.PubSub
end
