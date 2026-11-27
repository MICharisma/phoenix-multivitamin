defmodule PhoenixMultivitaminWeb.MtatsmindaRelief do
  @moduledoc false
  @enforce_keys [:position, :incoming, :minutes]
  defstruct [:position, :incoming, :minutes, posted_by: "Rota desk"]

  @positions ~w(Tower Ground Approach)

  def positions, do: @positions

  def build(%{"position" => position, "incoming" => incoming, "minutes" => minutes}) do
    with true <- position in @positions || {:error, :unknown_position},
         incoming when incoming != "" <- String.trim(incoming),
         {minutes, ""} <- Integer.parse(minutes),
         true <- minutes in 10..90 || {:error, :relief_window} do
      {:ok, %__MODULE__{position: position, incoming: incoming, minutes: minutes}}
    else
      {:error, _reason} = rejected -> rejected
      "" -> {:error, :no_incoming_controller}
      :error -> {:error, :minutes_not_a_number}
      {_minutes, _unparsed} -> {:error, :minutes_not_a_number}
    end
  end
end
