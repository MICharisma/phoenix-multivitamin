defmodule PhoenixMultivitaminWeb.PerpignanTramontaneChannel do
  use Phoenix.Channel

  intercept ["runway_wind"]

  @crosswind_limits_kt %{"A320" => 38, "Q400" => 32, "ATR72" => 35, "C172" => 15}

  @impl true
  def join("tramontane:queue", %{"flight" => flight, "type" => type}, socket)
      when is_map_key(@crosswind_limits_kt, type) do
    limit = @crosswind_limits_kt[type]
    {:ok, %{flight: flight, limit_kt: limit}, assign(socket, flight: flight, limit_kt: limit)}
  end

  def join("tramontane:queue", _payload, _socket) do
    {:error, %{reason: "no demonstrated crosswind on file for that type"}}
  end

  @impl true
  def handle_out(
        "runway_wind",
        %{crosswind_kt: crosswind} = wind,
        %{assigns: %{limit_kt: limit}} = socket
      )
      when crosswind > limit do
    push(socket, "hold_for_tramontane", %{
      flight: socket.assigns.flight,
      runway: wind.runway,
      exceeds_by_kt: crosswind - limit
    })

    {:noreply, socket}
  end

  def handle_out("runway_wind", wind, socket) do
    push(
      socket,
      "runway_wind",
      Map.put(wind, :margin_kt, socket.assigns.limit_kt - wind.crosswind_kt)
    )

    {:noreply, socket}
  end

  @doc "Crosswind on the runway in use for a wind from `direction` degrees at `speed_kt`."
  def runway_wind(direction, speed_kt) do
    runway = if direction in 240..360 or direction in 0..59, do: "33", else: "15"
    angle = (direction - String.to_integer(runway) * 10) * :math.pi() / 180

    %{
      runway: runway,
      wind: "#{direction}/#{speed_kt}KT",
      crosswind_kt: round(abs(:math.sin(angle)) * speed_kt)
    }
  end
end
