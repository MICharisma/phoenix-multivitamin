defmodule PhoenixMultivitaminWeb.PauPyreneesChannel do
  use Phoenix.Channel

  @valleys %{
    "ossau" => %{name: "Vallée d'Ossau", lz: "Gabas helipad", flight_min: 14},
    "aspe" => %{name: "Vallée d'Aspe", lz: "Lescun meadow", flight_min: 19},
    "baretous" => %{
      name: "Vallée de Barétous",
      lz: "Arette-la-Pierre-Saint-Martin",
      flight_min: 22
    }
  }

  @impl true
  def join("pyrenees:dragon64", _payload, socket) do
    {:ok, %{role: socket.assigns.role}, socket}
  end

  @impl true
  def handle_in("page_crew", payload, %{assigns: %{role: "dispatcher"}} = socket) do
    case Map.fetch(@valleys, payload["valley"]) do
      {:ok, valley} ->
        callout =
          ~w(casualty altitude_m)a
          |> Map.new(&{&1, payload[Atom.to_string(&1)]})
          |> Map.merge(valley)
          |> Map.put(:paged_by, socket.assigns.callsign)
          |> Map.put(:paged_at, DateTime.utc_now() |> DateTime.truncate(:second))

        broadcast!(socket, "callout", callout)
        {:reply, {:ok, %{eta_min: valley.flight_min}}, socket}

      :error ->
        {:reply, {:error, %{reason: "no landing zone on file for that valley"}}, socket}
    end
  end

  def handle_in("page_crew", _payload, socket) do
    {:reply, {:error, %{reason: "only the CODIS dispatcher pages Dragon 64"}}, socket}
  end

  def handle_in("acknowledge", _payload, %{assigns: %{role: role, callsign: callsign}} = socket) do
    broadcast!(socket, "crew_ready", %{role: role, callsign: callsign})
    {:noreply, socket}
  end
end
