defmodule PhoenixMultivitaminWeb.ConstantaBlackSeaChannel do
  use Phoenix.Channel

  @frame_bytes 9
  @low_fuel_kg 400
  @platforms [{"Ana", 70}, {"Doina", 82}, {"Lebăda Est", 48}]

  @impl true
  def join("black_sea:tracks", _payload, socket), do: {:ok, assign(socket, :frames, 0)}

  @impl true
  def handle_in(
        "frame",
        {:binary,
         <<icao::unsigned-24, altitude_ft::unsigned-16, heading::unsigned-16,
           fuel_kg::unsigned-16>>},
        socket
      )
      when heading < 360 do
    frames = socket.assigns.frames + 1
    low_fuel = if fuel_kg < @low_fuel_kg, do: 1, else: 0

    broadcast!(socket, "track", %{
      icao: icao |> Integer.to_string(16) |> String.pad_leading(6, "0"),
      altitude_ft: altitude_ft,
      heading: heading,
      fuel_kg: fuel_kg,
      low_fuel: low_fuel == 1
    })

    {:reply, {:ok, {:binary, <<frames::unsigned-32, low_fuel::8>>}},
     assign(socket, :frames, frames)}
  end

  def handle_in("frame", {:binary, <<_icao::24, _alt::16, heading::16, _fuel::16>>}, socket) do
    {:reply, {:error, %{reason: "heading #{heading} is not a compass heading"}}, socket}
  end

  def handle_in("frame", {:binary, frame}, socket) do
    {:reply, {:error, %{reason: "frames are #{@frame_bytes} bytes", bytes: byte_size(frame)}},
     socket}
  end

  def handle_in("frame", %{} = _json_frame, socket) do
    {:reply, {:error, %{reason: "send tracker frames as binary"}}, socket}
  end

  def handle_in("platform_depths", _payload, socket) do
    depths =
      for {_name, depth_m} <- @platforms, into: <<length(@platforms)::8>>, do: <<depth_m::16>>

    {:reply, {:ok, {:binary, depths}}, socket}
  end

  @doc "Packs a tracker frame the way the AW139 tracker sends it."
  def pack_frame(icao, altitude_ft, heading, fuel_kg) do
    <<icao::24, altitude_ft::16, heading::16, fuel_kg::16>>
  end
end
