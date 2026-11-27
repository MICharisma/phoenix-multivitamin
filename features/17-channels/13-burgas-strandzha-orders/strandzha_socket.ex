defmodule PhoenixMultivitaminWeb.BurgasStrandzhaSocket do
  use Phoenix.Socket

  channel "strandzha:drops", PhoenixMultivitaminWeb.BurgasStrandzhaChannel

  @salt "burgas strandzha dispatch watch"
  @watch_seconds 12 * 60 * 60
  @roles ~w(tower helicopter lookout)

  @impl true
  def connect(_params, socket, %{auth_token: auth_token} = connect_info) do
    case Phoenix.Token.verify(socket, @salt, auth_token, max_age: @watch_seconds) do
      {:ok, %{role: role, callsign: callsign}} when role in @roles ->
        {:ok,
         assign(socket,
           role: role,
           callsign: callsign,
           user_agent: Map.get(connect_info, :user_agent, "unknown")
         )}

      {:ok, _unknown_role} ->
        {:error, %{reason: "role is not on the Strandzha drop net"}}

      {:error, reason} ->
        {:error, %{reason: Atom.to_string(reason)}}
    end
  end

  def connect(_params, _socket, _connect_info_without_auth_token) do
    {:error, %{reason: "auth_token required"}}
  end

  @impl true
  def id(%{assigns: %{role: "tower", callsign: callsign}}), do: "strandzha_tower:" <> callsign
  def id(_socket), do: nil

  def sign_watch(role, callsign, opts \\ []) when role in @roles do
    Phoenix.Token.sign(
      PhoenixMultivitaminWeb.Endpoint,
      @salt,
      %{role: role, callsign: callsign},
      opts
    )
  end
end
