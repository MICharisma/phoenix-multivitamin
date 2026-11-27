defmodule PhoenixMultivitaminWeb.NabateanWatchSender do
  @moduledoc false
  @behaviour Phoenix.PubSub.Sender

  @impl true
  def send(pid, watch, {:nabatean_hail, target, text}, state) when target in [:station, watch] do
    Kernel.send(pid, {:nabatean_hail, if(target == :station, do: :station, else: :watch), text})
    state
  end

  def send(_pid, _watch, {:nabatean_hail, _other_watch, _text}, state), do: state
end
