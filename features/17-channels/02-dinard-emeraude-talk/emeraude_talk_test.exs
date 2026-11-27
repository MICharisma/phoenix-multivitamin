defmodule PhoenixMultivitaminWeb.DinardEmeraudeTalkTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.DinardEmeraudeSocket

  defp crew_socket(badge) do
    {:ok, socket} = connect(DinardEmeraudeSocket, %{badge: badge})
    socket
  end

  test "a rostered ramp lead joins her stand and calls chocks for the stand" do
    {:ok, reply, stand} =
      "DNR-0417"
      |> crew_socket()
      |> subscribe_and_join("emeraude:stand:2", %{turnaround: "FR5482"})

    assert reply == %{stand: "2", flight: "FR5482", crew: "Gwenaëlle Le Bihan"}

    ref = push(stand, "chocks_on")
    assert_reply ref, :ok
    assert_broadcast "chocks_on", %{stand: "2", flight: "FR5482", by: "Gwenaëlle Le Bihan"}
  end

  test "join refuses an unrostered stand, an unknown stand, a bad flight, and no flight" do
    marshaller = crew_socket("DNR-0522")

    assert {:error, %{reason: "Yann Tanguy is not rostered on stand 1"}} =
             join(marshaller, "emeraude:stand:1", %{turnaround: "FR5482"})

    assert {:error, %{reason: "Dinard has no stand 7"}} =
             join(marshaller, "emeraude:stand:7", %{turnaround: "FR5482"})

    assert {:error, %{reason: "EZY4417 is not a Dinard turnaround today"}} =
             join(marshaller, "emeraude:stand:3", %{turnaround: "EZY4417"})

    assert {:error, %{reason: "name the turnaround before joining a stand"}} =
             join(marshaller, "emeraude:stand:3", %{})
  end

  test "a loader on her stand cannot call chocks" do
    {:ok, _reply, stand} =
      join(crew_socket("DNR-0609"), "emeraude:stand:1", %{turnaround: "FR8851"})

    ref = push(stand, "chocks_on", %{})
    assert_reply ref, :error, %{reason: "only the ramp lead or marshaller calls chocks"}
  end

  test "an unknown badge and a missing badge never connect" do
    assert connect(DinardEmeraudeSocket, %{badge: "DNR-9999"}) == :error
    assert connect(DinardEmeraudeSocket, %{}) == :error
  end

  test "the stand form lists badges and stands for the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/02-dinard-emeraude-talk")

    assert has_element?(view, "#emeraude-talk[phx-hook$='.EmeraudeTalk'][phx-update='ignore']")
    assert has_element?(view, "#emeraude-talk option[value='DNR-0522']")
    assert has_element?(view, "#emeraude-talk option[value='4']")
  end
end
