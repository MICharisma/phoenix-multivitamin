defmodule PhoenixMultivitaminWeb.PantelleriaDeskChannel do
  use Phoenix.Channel

  @sensors ["RWY 08 threshold", "Montagna Grande ridge", "RWY 26 threshold"]

  @headwind_samples [
    %{sensor: "RWY 08 threshold", headwind_kt: 18},
    %{sensor: "Montagna Grande ridge", headwind_kt: 22},
    %{sensor: "RWY 26 threshold", headwind_kt: 4},
    %{sensor: "RWY 08 threshold", headwind_kt: 21}
  ]

  @shear_kt 15

  @impl true
  def join("pantelleria:anemometers", payload, socket) do
    cadence_ms = payload |> Map.get("cadence_ms", 2_000) |> max(10) |> min(10_000)
    send(self(), :after_join)

    {:ok, %{cadence_ms: cadence_ms},
     assign(socket, cadence_ms: cadence_ms, samples: @headwind_samples, last: nil, generation: 0)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    push(socket, "wind_table", %{runway: "08/26", sensors: @sensors, shear_kt: @shear_kt})
    {:noreply, schedule_sample(socket)}
  end

  def handle_info({:sample, generation}, %{assigns: %{generation: generation}} = socket) do
    [sample | rest] = socket.assigns.samples
    push(socket, "anemometer", sample)

    with %{headwind_kt: previous} <- socket.assigns.last,
         change when abs(change) >= @shear_kt <- sample.headwind_kt - previous do
      push(socket, "windshear_alert", %{sensor: sample.sensor, change_kt: change})
    end

    {:noreply, socket |> assign(samples: rest ++ [sample], last: sample) |> schedule_sample()}
  end

  def handle_info({:sample, _stale_generation}, socket), do: {:noreply, socket}

  @impl true
  def handle_in("pause_sampling", _payload, socket) do
    {:reply, {:ok, %{sensor_paused: socket.assigns.last && socket.assigns.last.sensor}},
     assign(socket, :generation, socket.assigns.generation + 1)}
  end

  def handle_in("resume_sampling", _payload, socket) do
    {:reply, :ok,
     socket |> assign(:generation, socket.assigns.generation + 1) |> schedule_sample()}
  end

  defp schedule_sample(%{assigns: %{cadence_ms: cadence_ms, generation: generation}} = socket) do
    Process.send_after(self(), {:sample, generation}, cadence_ms)
    socket
  end
end
