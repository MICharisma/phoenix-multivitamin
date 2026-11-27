# Telemetry and LiveDashboard · 05 · Lilongwe lake counts
#
# Teaches:
# - String.Chars lives in its own file; never nest defimpl beside the struct

defimpl String.Chars, for: PhoenixMultivitaminWeb.LilongweLakeReading do
  def to_string(%{metres: metres, waterbody: waterbody, station: station}) do
    "#{waterbody} at #{station}: #{metres} m visibility"
  end
end
