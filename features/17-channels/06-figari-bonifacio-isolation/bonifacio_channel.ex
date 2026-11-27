defmodule PhoenixMultivitaminWeb.FigariBonifacioChannel do
  use Phoenix.Channel

  @impl true
  def join("figari:apron", _payload, socket), do: {:ok, socket}

  @impl true
  def handle_in("isolate_stand", %{"stand" => stand, "hazard" => hazard}, socket) do
    case checklist(hazard) do
      [] ->
        {:reply, {:error, %{reason: "no isolation procedure for #{hazard}"}}, socket}

      steps ->
        isolation_ref = "FSC-ISO-#{stand}-#{socket.assigns.unit}"
        push(socket, "isolation_checklist", %{stand: stand, steps: steps})

        broadcast_from!(socket, "stand_isolated", %{
          stand: stand,
          hazard: hazard,
          by: socket.assigns.unit
        })

        {:reply, {:ok, %{isolation_ref: isolation_ref}}, socket}
    end
  end

  def handle_in("lift_isolation", %{"stand" => stand}, socket) do
    broadcast!(socket, "isolation_lifted", %{stand: stand, by: socket.assigns.unit})
    {:noreply, socket}
  end

  defp checklist("fuel_spill") do
    [
      "Stop the bowser and the APU",
      "Call the fire tender to the stand",
      "Spread absorbent from the bin at stand 3"
    ]
  end

  defp checklist("hydraulic_leak"), do: ["Chock and pin the gear", "Drip tray under the leak"]
  defp checklist(_unknown_hazard), do: []
end
