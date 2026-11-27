defmodule PhoenixMultivitaminWeb.PauPyreneesSocket do
  use Phoenix.Socket

  channel "pyrenees:dragon64", PhoenixMultivitaminWeb.PauPyreneesChannel

  @roles ~w(dispatcher pilot winch_operator doctor)

  @impl true
  def connect(%{"role" => role, "callsign" => callsign}, socket, _connect_info)
      when role in @roles and callsign != "" do
    {:ok, assign(socket, role: role, callsign: callsign)}
  end

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(_socket), do: nil
end
