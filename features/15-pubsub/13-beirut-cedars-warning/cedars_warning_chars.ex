defimpl String.Chars, for: PhoenixMultivitaminWeb.CedarsWarning do
  def to_string(warning) do
    "#{warning.hazard} on runway #{warning.runway} (#{warning.issued_by})"
  end
end
