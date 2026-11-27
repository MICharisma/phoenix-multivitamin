defimpl String.Chars, for: PhoenixMultivitaminWeb.DubrovnikStandCrew do
  def to_string(%{stand: stand, agents: agents}) do
    roll = Enum.map_join(agents, ", ", fn {agent, role} -> "#{agent} (#{role})" end)
    "Stand #{stand} · #{length(agents)} crew: #{roll}"
  end
end
