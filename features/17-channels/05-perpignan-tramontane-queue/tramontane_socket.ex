defmodule PhoenixMultivitaminWeb.PerpignanTramontaneSocket do
  use Phoenix.Socket

  channel "tramontane:queue", PhoenixMultivitaminWeb.PerpignanTramontaneChannel

  @impl true
  def connect(_params, socket, _connect_info), do: {:ok, socket}

  @impl true
  def id(_socket), do: nil
end
