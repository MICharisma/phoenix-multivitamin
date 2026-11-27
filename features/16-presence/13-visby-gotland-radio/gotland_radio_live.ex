# Presence · 13 · Visby Gotland radio
#
# Teaches:
# - Capstone: track on connect, update/4 from a validated form, untrack and track again, and two consoles under one call sign.
# - A fetch/2 overlay adds each station's site and operator, so the LiveView never looks them up.
# - Each presence_diff rebuilds an enforced-key net struct; comparing two snapshots yields the radio log, idempotently.

defmodule PhoenixMultivitaminWeb.VisbyGotlandRadioLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.GotlandRadioNet, as: RadioNet
  alias PhoenixMultivitaminWeb.VisbyGotlandPresence, as: NetPresence

  @topic "presence:gotland-radio-net"
  @lowest_mhz 118.0
  @highest_mhz 136.975

  @impl true
  def mount(params, _session, socket) do
    call_sign = params["station"] || "Visby Radio"
    frequency = "118.300"

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)
      {:ok, _ref} = NetPresence.track(self(), @topic, call_sign, %{frequency: frequency})
    end

    {:ok,
     socket
     |> assign_scenario("Visby Gotland radio", call_sign, "Saab 340 air ambulance")
     |> assign(frequency: frequency, on_net?: connected?(socket), form: retune_form(frequency))
     |> assign(:net, RadioNet.from_presences(NetPresence.list(@topic)))
     |> stream_configure(:radio_log, dom_id: &"radio-log-#{elem(&1, 0)}")
     |> stream(:radio_log, [])}
  end

  @impl true
  def handle_event(
        "retune",
        %{"retune" => %{"frequency" => entered}},
        %{assigns: %{on_net?: true}} = socket
      ) do
    with {mhz, ""} <- Float.parse(String.trim(entered)),
         true <- mhz >= @lowest_mhz and mhz <= @highest_mhz do
      frequency = :erlang.float_to_binary(mhz, decimals: 3)

      {:ok, _ref} =
        NetPresence.update(self(), @topic, socket.assigns.clerk, &%{&1 | frequency: frequency})

      {:noreply, assign(socket, frequency: frequency, form: retune_form(frequency))}
    else
      _rejected ->
        error = {"must be an airband frequency from 118.000 to 136.975 MHz", []}
        {:noreply, assign(socket, :form, retune_form(entered, frequency: error))}
    end
  end

  def handle_event("retune", _params, socket) do
    {:noreply, put_flash(socket, :error, "Sign on to the net before retuning.")}
  end

  def handle_event("sign_off", _params, %{assigns: %{clerk: call_sign}} = socket) do
    :ok = NetPresence.untrack(self(), @topic, call_sign)
    {:noreply, assign(socket, :on_net?, false)}
  end

  def handle_event(
        "sign_on",
        _params,
        %{assigns: %{clerk: call_sign, frequency: frequency}} = socket
      ) do
    {:ok, _ref} = NetPresence.track(self(), @topic, call_sign, %{frequency: frequency})
    {:noreply, assign(socket, :on_net?, true)}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    net = RadioNet.from_presences(NetPresence.list(@topic))

    log_lines =
      for change <- RadioNet.changes(socket.assigns.net, net) do
        {System.unique_integer([:positive, :monotonic]), log_line(change)}
      end

    {:noreply,
     socket
     |> assign(:net, net)
     |> stream(:radio_log, log_lines, limit: -10)}
  end

  defp retune_form(frequency, errors \\ []) do
    to_form(%{"frequency" => frequency}, as: :retune, errors: errors)
  end

  defp log_line({:joined, call_sign, site}), do: "#{call_sign} joined the net from #{site}"
  defp log_line({:left, call_sign}), do: "#{call_sign} left the net"
  defp log_line({:console_opened, call_sign, count}), do: "#{call_sign} opened console #{count}"

  defp log_line({:console_closed, call_sign, count}),
    do: "#{call_sign} is down to #{count} console(s)"

  defp log_line({:retuned, call_sign, frequencies}),
    do: "#{call_sign} now on #{Enum.join(frequencies, " and ")}"

  defp station_id(call_sign) do
    slug =
      call_sign
      |> String.normalize(:nfd)
      |> String.replace(~r/\p{Mn}/u, "")
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]+/, "-")

    "station-" <> slug
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 13 · Visby Gotland radio
      </p>

      <h1>Visby Gotland radio</h1>
      <p class="lede">
        {@clerk} keeps the Gotland radio net open while the {@craft} shuttles between Visby and
        Stockholm. Stations join, retune, open a second console, and sign off; the log records it.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="scenario mt-6 flex flex-wrap items-end gap-4">
        <.form for={@form} id="retune-form" phx-submit="retune">
          <.input field={@form[:frequency]} type="text" label="Frequency (MHz)" />
          <button
            id="retune"
            type="submit"
            class="rounded-lg bg-green-900 px-4 py-2 text-white transition hover:bg-green-800"
          >
            Retune
          </button>
        </.form>
        <button
          :if={@on_net?}
          id="sign-off"
          type="button"
          phx-click="sign_off"
          class="rounded-lg border border-stone-300 px-4 py-2 transition hover:bg-stone-100"
        >
          Sign off the net
        </button>
        <button
          :if={!@on_net?}
          id="sign-on"
          type="button"
          phx-click="sign_on"
          class="rounded-lg border border-stone-300 px-4 py-2 transition hover:bg-stone-100"
        >
          Sign on to the net
        </button>
      </div>

      <table id="radio-net" class="mt-6">
        <tr :for={{call_sign, station} <- Enum.sort(@net.stations)} id={station_id(call_sign)}>
          <th>{call_sign}</th>
          <td>{station.operator} at {station.site}</td>
          <td class="frequencies">{Enum.join(station.frequencies, " / ")}</td>
          <td class="consoles">{station.consoles}</td>
        </tr>
      </table>

      <ol id="radio-log" phx-update="stream" class="watch-log mt-6">
        <li id="radio-log-empty" class="hidden only:block">The net is quiet.</li>
        <li :for={{dom_id, {_seq, line}} <- @streams.radio_log} id={dom_id}>{line}</li>
      </ol>
    </Layouts.app>
    """
  end
end
