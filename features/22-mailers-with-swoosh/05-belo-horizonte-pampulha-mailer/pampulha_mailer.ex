# Mailers with Swoosh · 05 · Belo Horizonte Pampulha mailer
#
# Teaches:
# - The Test adapter as the mix test mailer
# - assert_email_sent / refute_email_sent pairing around release versus hold
# - A filtered for comprehension choosing which lagoon legs go out

defmodule PhoenixMultivitaminWeb.BeloHorizontePampulhaMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer

  @legs [
    %{lane: "north", craft: "Embraer Phenom 300", clerk: "Helena"},
    %{lane: "lagoon", craft: "Cessna Citation", clerk: "Igor"},
    %{lane: "south", craft: "Embraer Legacy 450", clerk: "Teresa"}
  ]

  def release_lagoon_legs do
    for %{lane: "lagoon"} = leg <- @legs do
      email =
        new()
        |> to({leg.clerk, "#{String.downcase(leg.clerk)}@sbbh.gov.br"})
        |> from({"Pampulha lagoon board", "lagoon@sbbh.gov.br"})
        |> subject("Pampulha #{leg.lane} release · #{leg.craft}")
        |> text_body("#{leg.clerk} releases the #{leg.craft} over the lagoon.")

      {:ok, _} = Mailer.deliver(email)
      email
    end
  end

  def hold_all_legs, do: :held
end
