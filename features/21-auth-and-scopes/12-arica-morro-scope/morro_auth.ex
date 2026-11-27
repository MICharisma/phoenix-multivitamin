# Auth and scopes · 12 · Arica Morro scope
#
# Teaches:
# - can?/2 with defguard and multi-head permission checks
# - Marshaller can clear runway; clerk cannot
# - Wrong-station scopes are forbidden for the Arica board

defmodule PhoenixMultivitaminWeb.MorroAuth do
  @moduledoc false

  alias PhoenixMultivitaminWeb.MorroScope

  defguard is_marshaller(scope)
           when is_struct(scope, MorroScope) and scope.role == :marshaller

  defguard is_arica(scope)
           when is_struct(scope, MorroScope) and scope.station == "ARI"

  def can?(%MorroScope{station: "ARI", role: :marshaller}, :clear_runway), do: true
  def can?(%MorroScope{station: "ARI"}, :clear_runway), do: false
  def can?(%MorroScope{}, :clear_runway), do: false

  def can?(%MorroScope{station: "ARI"}, :open_arica_board), do: true
  def can?(%MorroScope{}, :open_arica_board), do: false
  def can?(nil, _), do: false

  def open_arica_board(%MorroScope{} = scope) do
    if can?(scope, :open_arica_board) do
      {:ok, scope}
    else
      {:error, :forbidden}
    end
  end

  def open_arica_board(nil), do: {:error, :forbidden}

  def clear_runway(%MorroScope{} = scope) do
    if can?(scope, :clear_runway) do
      {:ok, :runway_cleared}
    else
      {:error, :forbidden}
    end
  end

  def clear_runway(nil), do: {:error, :forbidden}
end
