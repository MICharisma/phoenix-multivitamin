defmodule PhoenixMultivitaminWeb.AlderneyCasquetsSocket do
  use Phoenix.Socket

  channel "casquets:wire", PhoenixMultivitaminWeb.AlderneyCasquetsChannel

  @salt "alderney casquets dispatch shift"
  @shift_seconds 8 * 60 * 60

  @impl true
  def connect(%{"shift_token" => shift_token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, @salt, shift_token, max_age: @shift_seconds) do
      {:ok, {dispatcher, desk}} ->
        {:ok, assign(socket, dispatcher: dispatcher, desk: desk)}

      {:error, reason} ->
        {:error, %{reason: Atom.to_string(reason)}}
    end
  end

  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(socket), do: desk_topic(socket.assigns.desk)

  def desk_topic(desk), do: "casquets_desk:" <> desk

  def sign_shift(dispatcher, desk, opts \\ []) do
    Phoenix.Token.sign(PhoenixMultivitaminWeb.Endpoint, @salt, {dispatcher, desk}, opts)
  end
end
