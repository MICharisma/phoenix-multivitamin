# Mailers with Swoosh · 10 · Luxor Nile mailer
#
# Teaches:
# - A tiny Swoosh.Adapter that returns {:error, reason} for domain failures
# - Keeping the failure in-process so tests never touch a real SMTP host

defmodule PhoenixMultivitaminWeb.LuxorNileFailingAdapter do
  @moduledoc false
  use Swoosh.Adapter

  @impl true
  def deliver(%Swoosh.Email{subject: subject} = email, _config) do
    if String.contains?(subject, "runway-closed") do
      {:error, {:runway_closed, email.to}}
    else
      {:ok, %{id: "nile-ok"}}
    end
  end
end
