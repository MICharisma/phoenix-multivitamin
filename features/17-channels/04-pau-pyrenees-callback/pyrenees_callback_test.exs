defmodule PhoenixMultivitaminWeb.PauPyreneesCallbackTest do
  use PhoenixMultivitaminWeb.ChannelCase

  import Phoenix.ConnTest, except: [connect: 1, connect: 2, connect: 3]
  import Phoenix.LiveViewTest, except: [assert_reply: 2, assert_reply: 3]

  alias PhoenixMultivitaminWeb.PauPyreneesSocket

  defp sign_in(role, callsign) do
    {:ok, socket} = connect(PauPyreneesSocket, %{role: role, callsign: callsign})
    {:ok, %{role: ^role}, crew} = subscribe_and_join(socket, "pyrenees:dragon64")
    crew
  end

  test "the dispatcher's callout is broadcast and pushed to every crew socket, sender included" do
    dispatcher = sign_in("dispatcher", "CODIS 64 Lucie Etcheverry")
    _winch = sign_in("winch_operator", "Dragon 64 Winch Inès Bordenave")

    ref =
      push(dispatcher, "page_crew", %{
        valley: "ossau",
        casualty: "Hiker, suspected ankle fracture",
        altitude_m: 1870
      })

    assert_reply ref, :ok, %{eta_min: 14}

    assert_broadcast "callout", %{
      lz: "Gabas helipad",
      altitude_m: 1870,
      paged_by: "CODIS 64 Lucie Etcheverry"
    }

    assert_push "callout", %{name: "Vallée d'Ossau"}
    assert_push "callout", %{casualty: "Hiker, suspected ankle fracture"}
    refute_push "callout", _third_copy
  end

  test "crew members cannot page, and an unknown valley is refused" do
    winch = sign_in("winch_operator", "Dragon 64 Winch Inès Bordenave")
    ref = push(winch, "page_crew", %{valley: "ossau"})
    assert_reply ref, :error, %{reason: "only the CODIS dispatcher pages Dragon 64"}

    dispatcher = sign_in("dispatcher", "CODIS 64 Lucie Etcheverry")
    ref = push(dispatcher, "page_crew", %{valley: "vallée de la lune"})
    assert_reply ref, :error, %{reason: "no landing zone on file for that valley"}
    refute_broadcast "callout", _callout
  end

  test "an acknowledgement is broadcast without a reply" do
    doctor = sign_in("doctor", "SAMU 64 Dr Pierre Casenave")
    ref = push(doctor, "acknowledge")

    assert_broadcast "crew_ready", %{role: "doctor", callsign: "SAMU 64 Dr Pierre Casenave"}
    refute_reply ref, _status
  end

  test "an unknown role or blank callsign does not connect" do
    assert connect(PauPyreneesSocket, %{role: "journalist", callsign: "France 3"}) == :error
    assert connect(PauPyreneesSocket, %{role: "pilot", callsign: ""}) == :error
  end

  test "the crew board offers each role to the JS client" do
    {:ok, view, _html} = live(build_conn(), "/features/17-channels/04-pau-pyrenees-callback")
    assert has_element?(view, "#pyrenees-callback option[value='winch_operator']")
    assert has_element?(view, "#pyrenees-callback template[data-callout-row]")
  end
end
