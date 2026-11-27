# Auth and scopes · 02 · Arequipa Misti scope
#
# Teaches:
# - A small scope struct for the ash desk dispatcher and station
# - from_token/1 turns a session token into a scope or nil

defmodule PhoenixMultivitaminWeb.MistiScope do
  @moduledoc false

  defstruct [:dispatcher, :station]

  @type t :: %__MODULE__{dispatcher: String.t(), station: String.t()}

  def from_token("ines-aqp") do
    %__MODULE__{dispatcher: "Inés", station: "AQP"}
  end

  def from_token(_), do: nil
end
