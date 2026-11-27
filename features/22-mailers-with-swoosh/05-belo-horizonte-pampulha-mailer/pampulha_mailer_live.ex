# Mailers with Swoosh · 05 · Belo Horizonte Pampulha mailer
#
# Teaches:
# - Releasing lagoon legs through the Test adapter from the board
# - Holding the board so refute_email_sent can prove silence

defmodule PhoenixMultivitaminWeb.BeloHorizontePampulhaMailerLive do
  @moduledoc false
  use PhoenixMultivitaminWeb, :live_view

  alias PhoenixMultivitaminWeb.BeloHorizontePampulhaMailer

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_scenario("Belo Horizonte Pampulha mailer", "Igor", "Cessna Citation")
     |> assign(:station, "Pampulha · lagoon board")
     |> assign(:board_state, :quiet)
     |> assign(:released_count, 0)
     |> assign(:last_subjects, [])}
  end

  @impl true
  def handle_event("release_lagoon", _params, socket) do
    emails = BeloHorizontePampulhaMailer.release_lagoon_legs()

    {:noreply,
     socket
     |> assign(:board_state, :released)
     |> assign(:released_count, length(emails))
     |> assign(:last_subjects, Enum.map(emails, & &1.subject))}
  end

  def handle_event("hold_board", _params, socket) do
    :held = BeloHorizontePampulhaMailer.hold_all_legs()

    {:noreply,
     socket
     |> assign(:board_state, :held)
     |> assign(:released_count, 0)
     |> assign(:last_subjects, [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link>
        · Mailers with Swoosh · 05 · Belo Horizonte Pampulha mailer
      </p>

      <header class="masthead">
        <h1>Belo Horizonte Pampulha mailer</h1>
        <p class="lede">
          Igor's lagoon board releases only the lagoon lane through the Test adapter,
          or holds the whole board so nothing lands in the test mailbox.
        </p>
      </header>

      <.scenario_identity clerk={@clerk} craft={@craft} />

      <dl class="station-meta">
        <dt>Station</dt>
        <dd id="station-name">{@station}</dd>
        <dt>Board</dt>
        <dd id="board-state">{@board_state}</dd>
        <dt>Released</dt>
        <dd id="released-count">{@released_count}</dd>
      </dl>

      <ul id="released-subjects" class="scenario">
        <li :for={subject <- @last_subjects} id={"subject-#{subject}"}>{subject}</li>
      </ul>

      <div class="watch-actions">
        <button id="release-lagoon" type="button" phx-click="release_lagoon">
          Release lagoon legs
        </button>
        <button id="hold-board" type="button" phx-click="hold_board">Hold the board</button>
      </div>
    </Layouts.app>
    """
  end
end
