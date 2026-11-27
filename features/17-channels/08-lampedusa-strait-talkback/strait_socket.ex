defmodule PhoenixMultivitaminWeb.LampedusaStraitSocket do
  use Phoenix.Socket

  channel "strait:talkback", PhoenixMultivitaminWeb.LampedusaStraitChannel

  @impl true
  def connect(params, socket, _connect_info) do
    case params do
      %{"operator" => operator, "console" => console}
      when console in ["MRCC Roma", "Lampedusa Radio"] ->
        {:ok, assign(socket, operator: operator, console: console)}

      _missing_or_foreign_console ->
        :error
    end
  end

  @impl true
  def id(_socket), do: nil
end
