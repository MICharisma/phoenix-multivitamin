defmodule PhoenixMultivitaminWeb.DubrovnikStandCrew do
  @moduledoc false
  @enforce_keys [:stand, :agents]
  defstruct [:stand, :agents]

  @turnaround_roles MapSet.new(~w(marshaller loader fueller))

  def from_presence({stand, %{metas: metas}}) do
    agents =
      metas
      |> Enum.map(&{&1.agent, &1.role})
      |> Enum.uniq()
      |> Enum.sort()

    %__MODULE__{stand: stand, agents: agents}
  end

  def missing_roles(%__MODULE__{agents: agents}) do
    staffed = MapSet.new(agents, &elem(&1, 1))

    @turnaround_roles
    |> MapSet.difference(staffed)
    |> Enum.sort()
  end
end
