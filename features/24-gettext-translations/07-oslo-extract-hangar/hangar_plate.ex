defmodule PhoenixMultivitaminWeb.OsloHangarPlate do
  @moduledoc false

  @enforce_keys [:tail, :bay]
  defstruct [:tail, :bay, :note]

  def new(tail, bay, note \\ nil) when is_binary(tail) and is_binary(bay) do
    %__MODULE__{tail: tail, bay: bay, note: note}
  end
end
