# Auth and scopes · 12 · Arica Morro scope
#
# Teaches:
# - Scope carries role and station for permission checks
# - Roles :marshaller | :clerk

defmodule PhoenixMultivitaminWeb.MorroScope do
  @moduledoc false

  defstruct [:name, :role, :station]

  @type role :: :marshaller | :clerk
  @type t :: %__MODULE__{name: String.t(), role: role(), station: String.t()}

  def for_badge("diego-ari") do
    %__MODULE__{name: "Diego", role: :marshaller, station: "ARI"}
  end

  def for_badge("pilar-ari") do
    %__MODULE__{name: "Pilar", role: :clerk, station: "ARI"}
  end

  def for_badge("diego-tcq") do
    %__MODULE__{name: "Diego", role: :marshaller, station: "TCQ"}
  end

  def for_badge(_), do: nil
end
