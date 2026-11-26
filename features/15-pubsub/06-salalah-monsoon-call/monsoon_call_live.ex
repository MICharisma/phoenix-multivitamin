# PubSub · 06 · Salalah monsoon call
#
# Teaches:
# - Phoenix.PubSub.unsubscribe/2 when the desk stops following, with no terminate/2 cleanup
# - attach_hook/4 on :handle_info replaces a handle_info/2 callback; detach_hook/3 drops it
# - A socket-matching event head refuses a second subscribe, which would double every call

defmodule PhoenixMultivitaminWeb.SalalahMonsoonCallLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  @topic "salalah:monsoon-runway-calls"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Salalah monsoon call", "Hamed", "Boeing 787-8")
     |> assign(following?: false, calls: [])}
  end

  @impl true
  def handle_event("follow_calls", _params, %{assigns: %{following?: false}} = socket) do
    :ok = Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

    {:noreply,
     socket
     |> attach_hook(:monsoon_calls, :handle_info, &take_runway_call/2)
     |> assign(:following?, true)}
  end

  def handle_event("follow_calls", _params, socket), do: {:noreply, socket}

  def handle_event("stop_following", _params, %{assigns: %{following?: true}} = socket) do
    :ok = Phoenix.PubSub.unsubscribe(PhoenixMultivitamin.PubSub, @topic)

    {:noreply,
     socket
     |> detach_hook(:monsoon_calls, :handle_info)
     |> assign(:following?, false)}
  end

  def handle_event("stop_following", _params, socket), do: {:noreply, socket}

  defp take_runway_call({:runway_call, runway, condition}, socket) do
    {:halt, update(socket, :calls, &["#{runway}: #{condition}" | &1])}
  end

  defp take_runway_call(_other, socket), do: {:cont, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · PubSub · 06 · Salalah monsoon call
      </p>
      <header class="masthead">
        <h1>Salalah monsoon call</h1>
        <p class="lede">
          {@clerk} follows runway calls on the Salalah apron only while the khareef drizzle
          is in. Leaving the page needs no cleanup: the subscription dies with the process.
        </p>
      </header>
      <.scenario_identity clerk={@clerk} craft={@craft} />

      <div class="watch-actions">
        <button :if={!@following?} id="follow-calls" type="button" phx-click="follow_calls"
          class="rounded-lg bg-green-900 px-5 py-2 text-white transition hover:bg-green-800">
          Follow runway calls
        </button>
        <button :if={@following?} id="stop-following" type="button" phx-click="stop_following"
          class="rounded-lg border border-green-900 px-5 py-2 text-green-900 transition hover:bg-green-50">
          Stop following
        </button>
      </div>
      <p id="follow-state">{if @following?, do: "Following", else: "Not following"}</p>
      <.link id="leave-apron" navigate={~p"/"} class="underline">Leave the apron desk</.link>

      <ul id="runway-calls" class="watch-log">
        <li :for={call <- @calls}>{call}</li>
      </ul>
    </Layouts.app>
    """
  end
end
