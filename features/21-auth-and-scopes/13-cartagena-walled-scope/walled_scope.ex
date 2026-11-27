# Auth and scopes · 13 · Cartagena walled scope
#
# Teaches:
# - Capstone scope for the walled-harbour clerk and station
# - put_authenticated_at/2 for session renewal

defmodule PhoenixMultivitaminWeb.WalledScope do
  @moduledoc false

  defstruct [:clerk, :station, :authenticated_at]

  @type t :: %__MODULE__{
          clerk: String.t(),
          station: String.t(),
          authenticated_at: DateTime.t()
        }

  def for_clerk(clerk, station, authenticated_at \\ DateTime.utc_now())
      when is_binary(clerk) and is_binary(station) and is_struct(authenticated_at, DateTime) do
    %__MODULE__{clerk: clerk, station: station, authenticated_at: authenticated_at}
  end

  def put_authenticated_at(%__MODULE__{} = scope, %DateTime{} = at) do
    %{scope | authenticated_at: at}
  end

  def cartagena?(%__MODULE__{station: "CTG"}), do: true
  def cartagena?(_), do: false
end
