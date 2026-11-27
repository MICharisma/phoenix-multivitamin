defmodule PhoenixMultivitaminWeb.RigaOperatorRoster do
  @moduledoc false

  @roster %{
    "LV-OCC-1184" => %{name: "Jānis Bērziņš", desk: "Crew control", languages: ~w(lv en ru)},
    "LV-OCC-2207" => %{name: "Ilze Kalniņa", desk: "Maintenance control", languages: ~w(lv en de)},
    "LV-OCC-3051" => %{name: "Aleksandrs Ozols", desk: "Network control", languages: ~w(lv ru en)},
    "LV-OCC-4420" => %{name: "Laura Liepa", desk: "Duty manager", languages: ~w(lv en)}
  }

  def profiles(licences), do: Map.take(@roster, licences)
end
