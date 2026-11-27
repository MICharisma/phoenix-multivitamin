defmodule PhoenixMultivitaminWeb.DinardEmeraudeSocket do
  use Phoenix.Socket

  channel "emeraude:stand:*", PhoenixMultivitaminWeb.DinardEmeraudeChannel

  @ramp_roster %{
    "DNR-0417" => %{name: "Gwenaëlle Le Bihan", role: :ramp_lead, stands: ~w(1 2 3)},
    "DNR-0522" => %{name: "Yann Tanguy", role: :marshaller, stands: ~w(3)},
    "DNR-0609" => %{name: "Soizic Kerhervé", role: :loader, stands: ~w(1)}
  }

  @impl true
  def connect(params, socket, _connect_info) do
    with %{"badge" => badge} <- params,
         {:ok, crew} <- Map.fetch(@ramp_roster, badge) do
      {:ok, assign(socket, :crew, Map.put(crew, :badge, badge))}
    else
      _no_badge_or_unknown -> :error
    end
  end

  @impl true
  def id(_socket), do: nil

  def badges, do: Map.keys(@ramp_roster)
end
