defmodule PhoenixMultivitaminWeb.OhridLakeChannel do
  use Phoenix.Channel

  @impl true
  def join(topic, _payload, socket) do
    case topic |> String.split(":") |> sector() do
      {:ok, sector} -> {:ok, sector, assign(socket, :sector, sector)}
      {:error, reason} -> {:error, %{reason: reason}}
    end
  end

  @impl true
  def handle_in("talk", %{"words" => words}, socket) do
    broadcast!(socket, "talk", %{callsign: socket.assigns.callsign, words: words})
    {:noreply, socket}
  end

  defp sector(["ohrid", "runway", runway]) when runway in ["02", "20"],
    do: {:ok, %{kind: "runway", name: "Runway #{runway}", frequency: "118.300"}}

  defp sector(["ohrid", "apron", stand]) do
    case Integer.parse(stand) do
      {number, ""} when number in 1..6 ->
        {:ok, %{kind: "apron", name: "Stand #{number}", frequency: "121.850"}}

      _not_a_stand ->
        {:error, "Ohrid has stands 1 to 6"}
    end
  end

  defp sector(["ohrid", "approach", side]) when side in ["lake", "galicica"],
    do:
      {:ok,
       %{kind: "approach", name: "Approach over #{String.capitalize(side)}", frequency: "120.700"}}

  defp sector(["ohrid", ""]), do: {:error, "name a sector after ohrid:"}
  defp sector(_segments), do: {:error, "no such sector at Ohrid"}
end
