# Presence · 07 · Kraków Wawel night staff
#
# Teaches:
# - Tracking starts on a sign-on event rather than on mount, and Presence.untrack/3 ends it while the tab stays open.
# - A second track for the same process, topic, and key returns {:error, {:already_tracked, pid, topic, key}}.
# - Function heads match the socket's duty state ({:on_duty, since} or :off_duty) to refuse out-of-order events.

defmodule PhoenixMultivitaminWeb.KrakowWawelNightStaffLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias Phoenix.Socket.Broadcast
  alias PhoenixMultivitaminWeb.Presence

  @topic "presence:krakow-night-ramp"

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:ok,
     socket
     |> assign_scenario(
       "Kraków Wawel night staff",
       params["agent"] || "Wojciech",
       "Ryanair 737-8200"
     )
     |> assign(:duty, :off_duty)
     |> assign_night_staff()}
  end

  @impl true
  def handle_event("sign_on", %{"post" => post}, %{assigns: %{clerk: agent}} = socket) do
    since = Time.utc_now() |> Time.truncate(:second)

    case Presence.track(self(), @topic, agent, %{post: post, since: since}) do
      {:ok, _ref} ->
        {:noreply, assign(socket, :duty, {:on_duty, since})}

      {:error, {:already_tracked, _pid, @topic, ^agent}} ->
        {:noreply, put_flash(socket, :error, "#{agent} is already signed on for the night.")}
    end
  end

  def handle_event(
        "sign_off",
        _params,
        %{assigns: %{duty: {:on_duty, _since}, clerk: agent}} = socket
      ) do
    :ok = Presence.untrack(self(), @topic, agent)
    {:noreply, assign(socket, :duty, :off_duty)}
  end

  def handle_event("sign_off", _params, %{assigns: %{duty: :off_duty}} = socket) do
    {:noreply, put_flash(socket, :error, "Nobody to sign off: this console is not on duty.")}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket),
    do: {:noreply, assign_night_staff(socket)}

  defp assign_night_staff(socket) do
    staff =
      @topic
      |> Presence.list()
      |> Enum.sort_by(fn {_agent, %{metas: [meta | _]}} -> meta.since end, Time)

    assign(socket, :night_staff, staff)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Presence · 07 · Kraków Wawel night staff
      </p>

      <h1>Kraków Wawel night staff</h1>
      <p class="lede">
        {@clerk} works the night ramp at Kraków while the last {@craft} is de-iced. Opening this
        page does not put anyone on duty; signing on does.
      </p>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="scenario mt-6">
        <%= case @duty do %>
          <% {:on_duty, since} -> %>
            <p id="duty-state">On duty since {Time.to_string(since)} UTC</p>
            <button
              id="sign-off"
              type="button"
              phx-click="sign_off"
              class="rounded-lg border border-stone-300 px-4 py-2 transition hover:bg-stone-100"
            >
              Sign off for the night
            </button>
          <% :off_duty -> %>
            <p id="duty-state">Off duty</p>
            <button
              id="sign-on-deice"
              type="button"
              phx-click="sign_on"
              phx-value-post="de-icing pad"
              class="rounded-lg bg-green-900 px-4 py-2 text-white transition hover:bg-green-800"
            >
              Sign on at the de-icing pad
            </button>
            <button
              id="sign-on-baggage"
              type="button"
              phx-click="sign_on"
              phx-value-post="baggage hall"
              class="rounded-lg bg-green-900 px-4 py-2 text-white transition hover:bg-green-800"
            >
              Sign on in the baggage hall
            </button>
        <% end %>
      </div>

      <ul id="night-staff" class="watch-log mt-6">
        <li
          :for={{agent, %{metas: [meta | _]}} <- @night_staff}
          id={"night-#{String.downcase(agent)}"}
        >
          {agent} · {meta.post}
        </li>
      </ul>
    </Layouts.app>
    """
  end
end
