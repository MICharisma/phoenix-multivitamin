# Ecto queries and contexts · 09 · Nairobi cargo totals
#
# Teaches:
# - group_by + having on summed kilograms
# - select map of airline totals that clear the threshold

defmodule PhoenixMultivitamin.NairobiCargoTotals do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.NairobiShipment
  alias PhoenixMultivitamin.Repo

  def airline_totals_above(min_kg) when is_integer(min_kg) do
    Repo.all(
      from shipment in NairobiShipment,
        group_by: shipment.airline,
        having: sum(shipment.kilograms) >= ^min_kg,
        order_by: [desc: sum(shipment.kilograms)],
        select: %{
          airline: shipment.airline,
          total_kg: sum(shipment.kilograms),
          legs: count(shipment.id)
        }
    )
  end
end
