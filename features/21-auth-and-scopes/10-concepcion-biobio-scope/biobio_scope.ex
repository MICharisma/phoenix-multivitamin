# Auth and scopes · 10 · Concepción Biobío scope
#
# Teaches:
# - Scope carries authenticated_at for sudo checks
# - put_authenticated_at/2 refreshes the stamp on session renewal

defmodule PhoenixMultivitaminWeb.BiobioScope do
  @moduledoc false

  defstruct [:clerk, :station, :authenticated_at]

  @type t :: %__MODULE__{
          clerk: String.t(),
          station: String.t(),
          authenticated_at: DateTime.t()
        }

  def for_clerk(clerk, authenticated_at \\ DateTime.utc_now())
      when is_binary(clerk) and is_struct(authenticated_at, DateTime) do
    %__MODULE__{clerk: clerk, station: "CCP", authenticated_at: authenticated_at}
  end

  def put_authenticated_at(%__MODULE__{} = scope, %DateTime{} = at) do
    %{scope | authenticated_at: at}
  end
end
