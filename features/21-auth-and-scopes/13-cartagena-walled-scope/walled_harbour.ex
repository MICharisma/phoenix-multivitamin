# Auth and scopes · 13 · Cartagena walled scope
#
# Teaches:
# - Scoped context: list_harbour_slips/1 only returns slips for CTG
# - Wrong-station scopes get {:error, :forbidden}

defmodule PhoenixMultivitaminWeb.WalledHarbour do
  @moduledoc false

  alias PhoenixMultivitaminWeb.WalledScope

  @slips [
    %{id: "slip-bocagrande", name: "Bocagrande seaplane slip", station: "CTG"},
    %{id: "slip-getsmani", name: "Getsemaní float ramp", station: "CTG"},
    %{id: "slip-manga", name: "Manga harbour berth", station: "CTG"},
    %{id: "slip-baq", name: "Barranquilla river buoy", station: "BAQ"}
  ]

  def list_harbour_slips(%WalledScope{station: "CTG"}) do
    {:ok, Enum.filter(@slips, &(&1.station == "CTG"))}
  end

  def list_harbour_slips(%WalledScope{}) do
    {:error, :forbidden}
  end

  def list_harbour_slips(nil), do: {:error, :forbidden}
end
